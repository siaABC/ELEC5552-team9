library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all; 
use STD.TEXTIO.all;  
use ieee.std_logic_unsigned.all;
 

entity FIR_filter_tb is 
end FIR_filter_tb; 
 
architecture testbench of FIR_filter_tb is 

component FIR_filter is 
  port(clk : in std_logic; 
       reset : in std_logic; 
             original_signal : in std_logic_vector(11 downto 0); 
       filtered_signal : out std_logic_vector(23 downto 0)); 
end component; 

  --signal clk : std_logic := '0'; 
  signal reset : std_logic; --circuit input for reset 
  signal original_signal : std_logic_vector(11 downto 0); --circuit input for original signal 
  signal filtered_signal : std_logic_vector(23 downto 0); 
  signal clk_sample : std_logic := '0'; 
  --signal clk_reset : std_logic := '0';
  file test_input : text open READ_MODE is "test_data.txt"; 
 
  begin 
 
  T1 : FIR_filter port map(clk => clk_sample, reset => reset, original_signal => original_signal, filtered_signal => filtered_signal); 
 
  reset <= '1'; 
  --,'0' after 250 ms;

   --reset_process:
   --process
  --begin
  --clk_reset <= '1';
  --wait for 300 ms;
  --clk_reset <= '0';
 --end process;

clk_process:
     process
      begin
      --if (clk_reset = '1') then 
      clk_sample <= '0';
      wait for 20 us;
     loop  
        clk_sample <= not clk_sample;
         wait for 20 us;
         end loop;
      --else
      --clk_sample <='0'; 
    --end if;
    
    end process;

main_process:

  process(clk_sample) 
    variable line_test_input : line; 
    variable input: integer; 
    begin 
      if rising_edge(clk_sample) then 
        readline(test_input, line_test_input);   
        read(line_test_input,input);   
        original_signal <= std_logic_vector(to_unsigned(input,12));     
      end if; 
  end process; 
end testbench;