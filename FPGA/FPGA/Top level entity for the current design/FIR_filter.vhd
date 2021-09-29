library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; 
 
entity FIR_filter is 
  port(clk : in std_logic; 
       reset : in std_logic; 
             original_signal : in std_logic_vector(11 downto 0); 
       filtered_signal : out std_logic_vector(23 downto 0)); 
end FIR_filter; 
 
architecture behavior of FIR_filter is 
  type coeffs is array (0 to 12) of signed(11 downto 0);  
  type previous_data_storage is array (0 to 12) of signed(11 downto 0);  
  type product_storage is array (0 to 12) of signed(23 downto 0); 
   
  signal coefficient : coeffs := (0 => "111111101111", 1 => "111110111000", 2 => 
"111111100101", 3 => "000001010011", 4 => "000001011100", 5 => "111111011011",  6 => "000111010101", 7 => "111111011011", 8 => "000001011100", 9 => 
"000001010011", 10 => "111111100101", 11 => "111110111000",12 => 
"111111101111"); 
  signal signal_memory : previous_data_storage; 
  signal prod : product_storage;  
  signal frequency_sample : std_logic_vector(11 downto 0); 
  signal sample_clk : std_logic;       --sampling clock 
  signal sample_clk_delay : std_logic;  --necessary to detect rising edge of non clock 
  signal sample_clk_edge : std_logic;  --used to signal rising edge in sample clock 
  signal sum : signed(23 downto 0); 
 
  begin 
  process(clk, reset) 
  begin 
  if reset = '1' then        --resets code       
    frequency_sample <= (others => '0'); 
    sample_clk <= '0'; 
    sample_clk_delay <= '0'; 
    sample_clk_edge <= '0'; 
    sum <= (others => '0'); 
    filtered_signal <= (others => '0');   --filtered output signal is cleared 
    signal_memory <= (others => ("000000000000")); 
    prod <= (others => ("000000000000000000000000")); 
  elsif rising_edge(clk) then 
    frequency_sample <= frequency_sample + 1; 
 
    if(frequency_sample = "001111101000" ) then   
      frequency_sample <= "000000000000";  --value reset 
      sample_clk_delay <= sample_clk;  
      sample_clk <= not sample_clk;    --toggle sampling clk 
      sample_clk_edge <= sample_clk and (not sample_clk_delay); 
      if sample_clk_edge = '1' then 
        signal_memory <= signed(original_signal) & signal_memory(0 TO 11);  
        sum <= (others => '0'); --ensure sum is cleared 
     
        for i in 0 to 12 loop 
          prod(i) <= signal_memory(i) * coefficient(i);   
        end loop; 
         
        sum <= 
prod(0)+prod(1)+prod(2)+prod(3)+prod(4)+prod(5)+prod(6)+prod(7)+prod(8)+prod(9)+
prod(10)+prod(11)+prod(12); 
 
        if sum(23)='1'  then 
          filtered_signal <= "000000000000000000000000";   
        else 
          filtered_signal <= std_logic_vector(sum srl 9);   
        end if; 
      end if; 
    end if; 
  end if; 
  end process;   
end behavior;