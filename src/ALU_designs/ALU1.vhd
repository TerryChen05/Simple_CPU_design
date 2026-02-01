LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU1 IS
	PORT(
			clk, res   : IN  STD_LOGIC;
			reg1, reg2 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			opcode     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			result     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END ALU1;

ARCHITECTURE calculation OF ALU1 IS
BEGIN

	PROCESS(clk, res)
	BEGIN
		IF res = '0' THEN
			result <= "00000000";
		ELSIF(clk'EVENT AND clk = '1') THEN
			CASE opcode IS
				WHEN "00000001" => 
						result <= reg1 + reg2; --sum(A, B)
				WHEN "00000010" =>
						result <= reg1 - reg2; --diff(A, B)
            WHEN "00000100" =>
						result <= NOT(reg1); --not(A)
            WHEN "00001000" =>
						result <= reg1 NAND reg2; --not(A and B)
            WHEN "00010000" =>
						result <= reg1 NOR reg2; --not(A or B)
            WHEN "00100000" =>
						result <= reg1 AND reg2; --A and B
            WHEN "01000000" =>
						result <= reg1 XOR reg2; --A xor B
            WHEN "10000000" =>
						result <= reg1 OR reg2; --A or B
            WHEN OTHERS =>
						result <= "00000000";
			END CASE;
		END IF;
	END PROCESS;
	
END calculation;