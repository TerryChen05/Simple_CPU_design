LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY decode IS
	PORT( 
			w 	: IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			En : IN STD_LOGIC ;
			y 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
	) ;
END decode ;

ARCHITECTURE behavior OF decode IS
	SIGNAL Enw : STD_LOGIC_VECTOR(3 DOWNTO 0) ;
BEGIN

	Enw <= En & w ;
	WITH Enw SELECT
		y <= 		
			"00000001" WHEN "1000", --sum(A, B)
			"00000010" WHEN "1001", --diff(A, B)
			"00000100" WHEN "1010", --not(A)
			"00001000" WHEN "1011", --not(A and B)
			"00010000" WHEN "1100", --not(A or B)
			"00100000" WHEN "1101", --A and B
			"01000000" WHEN "1110", --A xor B
			"10000000" WHEN "1111", --A or B
			"00000000" WHEN OTHERS ;

END behavior ;