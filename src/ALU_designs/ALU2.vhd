LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY ALU2 IS
	PORT(
			clk, res   : IN  STD_LOGIC;
			reg1, reg2 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			opcode     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			result     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ALU2;

ARCHITECTURE calculation OF ALU2 IS
BEGIN
	
	PROCESS(clk, res)
	BEGIN
		IF res = '0' THEN
				result <= "00000000";
		ELSIF(clk'EVENT AND clk = '1') THEN
			CASE opcode IS
					-- Function 1: Shift A right 2 bits, input bit = 1 (SHR)
					WHEN "00000001" =>
						result <= "11" & reg1(7 DOWNTO 2);
						
					-- Function 2: Difference of A and B, then increment by 4
               WHEN "00000010" =>
						result <= (reg1 - reg2) + "0100";
						
					-- Function 3: Find the greater value (Max(A, B))
               WHEN "00000100" =>
						IF (reg1 > reg2) THEN
							result <= reg1;
						ELSE
							result <= reg2;
						END IF;
					
					-- Function 4: Swap upper 4 bits of A with lower 4 bits of B
               -- (Result becomes: B_lower & A_lower)
               WHEN "00001000" =>
						result <= reg2(3 DOWNTO 0) & reg1(3 DOWNTO 0);
						
					-- Function 5: Increment A by 1
               WHEN "00010000" =>
						result <= reg1 + 1;
						
					-- Function 6: Result of ANDing A and B
               WHEN "00100000" =>
						result <= reg1 AND reg2;
						
					-- Function 7: Invert the upper four bits of A
               WHEN "01000000" =>
						result <= NOT(reg1(7 DOWNTO 4)) & reg1(3 DOWNTO 0);
						
					-- Function 8: Rotate B to left by 3 bits (ROL)
               WHEN "10000000" =>
						result <= reg2(4 DOWNTO 0) & reg2(7 DOWNTO 5);
						
					WHEN OTHERS => result <= "00000000";
			END CASE;
		END IF;
	END PROCESS;
	
END calculation;