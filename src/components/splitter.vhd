LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY splitter IS
	PORT(
			result		 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			res1, res2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			negL, negR : OUT STD_LOGIC
	);
END splitter;

ARCHITECTURE behavior of splitter is
	SIGNAL resL : STD_LOGIC_VECTOR(3 DOWNTO 0); --temporary results, res1/res2 are outputs
	SIGNAL resR : STD_LOGIC_VECTOR(3 DOWNTO 0); 
BEGIN

	res1 <= result(7 downto 4); --left 4 bits
	res2 <= result(3 downto 0); --right 4 bits
	
	resL <= result(7 downto 4);
	negL <= resL(3); --left sign bit
	
	resR <= result(3 downto 0);
	negR <= resR(3); --right sign bit
	
END behavior;
	