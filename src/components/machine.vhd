LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY machine IS
	PORT(
			data_in, clk, reset : IN  STD_LOGIC;
			student_id          : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			current_state       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END machine;

ARCHITECTURE fsm OF machine IS
    TYPE state_type IS (s0, s1, s2, s3, s4, s5, s6, s7);
    SIGNAL yfsm : state_type;
BEGIN

	PROCESS(clk, reset, data_in)
   BEGIN
		IF reset = '0' THEN
			yfsm <= s0;
      ELSIF (clk'EVENT AND clk = '1' AND data_in = '1') THEN
			CASE yfsm IS
				WHEN s0 => yfsm <= s1;
				WHEN s1 => yfsm <= s2;
				WHEN s2 => yfsm <= s3;
            WHEN s3 => yfsm <= s4;
            WHEN s4 => yfsm <= s5;
            WHEN s5 => yfsm <= s6;
            WHEN s6 => yfsm <= s7;
            WHEN s7 => yfsm <= s0;
			END CASE;
		END IF;
	END PROCESS;
	
	PROCESS(yfsm)
	BEGIN
		CASE yfsm IS
			WHEN s0 =>
					current_state <= "000";
               student_id    <= "0000";
			WHEN s1 =>
               current_state <= "001";
               student_id    <= "0001";
			WHEN s2 =>
               current_state <= "010";
               student_id    <= "0010";
         WHEN s3 =>
               current_state <= "011";
               student_id    <= "0011";
         WHEN s4 =>
               current_state <= "100";
               student_id    <= "0110";
         WHEN s5 =>
               current_state <= "101";
               student_id    <= "0001";
         WHEN s6 =>
               current_state <= "110";
               student_id    <= "0100";
         WHEN s7 =>
               current_state <= "111";
               student_id    <= "1000";
					 
		END CASE; -- id: 	  0  1  2  3  6  1  4  8
	END PROCESS; -- states: s0 s1 s2 s3 s4 s5 s6 s7
END fsm;


