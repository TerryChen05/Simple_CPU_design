LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY state_sseg IS
	PORT( 
			bcd 			 : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			sign 			 : IN STD_LOGIC ;
			leds1, leds2 : OUT STD_LOGIC_VECTOR(0 TO 6) 
	);
END state_sseg ;

ARCHITECTURE behavior OF state_sseg IS
BEGIN

	PROCESS(bcd)
	BEGIN
		CASE bcd IS -- abcdef
			WHEN "000" => leds1 <= "0000001"; --0
        	WHEN "001" => leds1 <= "1001111"; --1
        	WHEN "010" => leds1 <= "0010010"; --2
        	WHEN "011" => leds1 <= "0000110"; --3
        	WHEN "100" => leds1 <= "1001100"; --4
        	WHEN "101" => leds1 <= "0100100"; --5
        	WHEN "110" => leds1 <= "0100000"; --6
        	WHEN "111" => leds1 <= "0001111"; --7
			WHEN OTHERS => leds1 <= "-------";
		END CASE;
	END PROCESS;
	
	PROCESS(sign)
  	BEGIN
      IF (sign = '1') THEN
				leds2 <= "0000001";
      ELSE
				leds2 <= "1111110";  
    	END IF;
	END PROCESS;

END behavior ;