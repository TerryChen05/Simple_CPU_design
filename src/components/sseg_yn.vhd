LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY sseg_yn IS
	PORT( 
			bcd 			 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			sign 			 : IN STD_LOGIC;
			leds1, leds2 : OUT STD_LOGIC_VECTOR(0 TO 6) );
END sseg_yn;

ARCHITECTURE behavior OF sseg_yn IS
BEGIN

	PROCESS(bcd)
	BEGIN
		CASE bcd IS -- abcdef
			WHEN "0000" => leds1 <= "0000001"; --0
			WHEN "1110" => leds1 <= "1000100"; --y for even
        	WHEN "1111" => leds1 <= "1101010"; --n for odd
			WHEN OTHERS => leds1 <= "-------";
		END CASE ;
	END PROCESS ;
	
	PROCESS(sign)
  	BEGIN
		IF (sign = '1') THEN
				leds2 <= "0000001";
		ELSE
				leds2 <= "1111110";  
    	END IF;
	END PROCESS;

END behavior ;
