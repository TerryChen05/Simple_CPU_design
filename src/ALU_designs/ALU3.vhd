LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY ALU3 IS
	PORT(
			clk, res   : IN  STD_LOGIC;
			reg1, reg2 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Unused in Prob 3
			opcode     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Unused in Prob 3
			student_id : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			result     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  -- 4-bit output for 1 Hex digit
	);
END ALU3;

ARCHITECTURE calculation OF ALU3 IS
BEGIN
	PROCESS(clk, res)
	BEGIN
		IF res = '0' THEN
			result <= "0000" ;
		ELSIF (clk'EVENT AND clk = '1') THEN
			
			Result <= "111" & student_id(0); -- even: 1110, odd: 1111
			
      END IF;

    END PROCESS;
END calculation;
