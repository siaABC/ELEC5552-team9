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
  type coeffs is array (0 to 12) of signed(11 downto 0);      --coefficient storage 
  type previous_data_storage is array (0 to 12) of signed(11 downto 0);   --stores previous data 
  type product_storage is array (0 to 12) of signed(23 downto 0);  
   
  signal coefficient : coeffs := (0 => "111111101111", 1 => "111110111000", 2 => 
"111111100101", 3 => "000001010011", 4 => "000001011100", 5 => "111111011011", 
6 => "000111010101", 7 => "111111011011", 8 => "000001011100", 9 => 
"000001010011", 10 => "111111100101", 11 => "111110111000",12 => 
"111111101111"); 
  signal signal_memory : previous_data_storage; 
  signal prod : product_storage;  
  signal frequency_sample : std_logic_vector(11 downto 0); 
  signal sample_clk : std_logic;       --sampling clock 
  signal sample_clk_delay : std_logic; 
  signal sample_clk_edge : std_logic; 
  signal sum : signed(23 downto 0); 
  signal start : std_logic; 
  signal state : std_logic_vector(4 downto 0); 
 
  begin 
  process(clk, reset) 
  begin 
  if reset = '1' then        --resets code       
    frequency_sample <= (others => '0'); 
    sample_clk <= '0'; 
    sample_clk_delay <= '0'; 
    sample_clk_edge <= '0'; 
    start <= '0'; 
    sum <= (others => '0'); 
    filtered_signal <= (others => '0');   --filtered output signal is cleared 
    signal_memory <= (others => ("000000000000")); 
    prod <= (others => ("000000000000000000000000")); 
    state <= "00000"; 
  elsif rising_edge(clk) then 
    frequency_sample <= frequency_sample + 1; 
 
    if(frequency_sample = "001111101000" ) then   
      frequency_sample <= "000000000000";  --value reset 
      sample_clk_delay <= sample_clk;  
      sample_clk <= not sample_clk;    --toggle sampling clk 
      sample_clk_edge <= sample_clk and (not sample_clk_delay); 
      if sample_clk_edge = '1' then 
        start <= '1'; 
        state <= "00001"; 
      end if; 
    elsif start = '1' then 
      if state = "00001" then 
        signal_memory <= signed(original_signal) & 
signal_memory(0 TO 11);  
        state <= "00010"; 
      elsif state = "00010" then 
        sum <= (others => '0'); 
        state <= "00011"; 
      elsif state = "00011" then 
        prod(0) <= signal_memory(0) * coefficient(0); 
        state <= "00100"; 
      elsif state = "00100" then  
        prod(1) <= signal_memory(1) * coefficient(1); 
        state <= "00101"; 
      elsif state = "00101" then 
        prod(2) <= signal_memory(2) * coefficient(2); 
        state <= "00110"; 
      elsif state = "00110" then 
        prod(3) <= signal_memory(3) * coefficient(3); 
        state <= "00111"; 
      elsif state = "00111" then 
        prod(4) <= signal_memory(4) * coefficient(4); 
        state <= "01000"; 
      elsif state = "01000" then 
        prod(5) <= signal_memory(5) * coefficient(5); 
        state <= "01001"; 
      elsif state = "01001" then 
        prod(6) <= signal_memory(6) * coefficient(6); 
        state <= "01010"; 
      elsif state = "01010" then 
        prod(7) <= signal_memory(7) * coefficient(7); 
        state <= "01011"; 
      elsif state = "01011" then 
        prod(8) <= signal_memory(8) * coefficient(8); 
        state <= "01100"; 
      elsif state = "01100" then 
        prod(9) <= signal_memory(9) * coefficient(9); 
        state <= "01101"; 
      elsif state = "01101" then 
        prod(10) <= signal_memory(10) * coefficient(10); 
        state <= "01110"; 
      elsif state = "01110" then 
        prod(11) <= signal_memory(11) * coefficient(11); 
        state <= "01111"; 
      elsif state = "01111" then 
        prod(12) <= signal_memory(12) * coefficient(12); 
        state <= "10000"; 
      elsif state = "10000" then 
        sum <= prod(0); 
        state <= "10001"; 
      elsif state = "10001" then 
        sum <= sum + prod(1); 
        state <= "10010"; 
      elsif state = "10010" then 
        sum <= sum + prod(2); 
        state <= "10011"; 
      elsif state = "10011" then 
        sum <= sum + prod(3); 
        state <= "10100"; 
      elsif state = "10100" then 
        sum <= sum + prod(4); 
        state <= "10101"; 
      elsif state = "10101" then 
        sum <= sum + prod(5); 
        state <= "10110"; 
      elsif state = "10110" then 
        sum <= sum + prod(6); 
        state <= "10111"; 
      elsif state = "10111" then 
        sum <= sum + prod(7); 
        state <= "11000"; 
      elsif state = "11000" then 
        sum <= sum + prod(8); 
        state <= "11001"; 
      elsif state = "11001" then 
        sum <= sum + prod(9); 
        state <= "11010"; 
      elsif state = "11010" then 
        sum <= sum + prod(10); 
        state <= "11011"; 
      elsif state = "11011" then 
        sum <= sum + prod(11); 
        state <= "11100"; 
      elsif state = "11100" then 
        sum <= sum + prod(12); 
        state <= "11101"; 
      elsif state = "11101" then 
        if sum(23)='1'  then 
          filtered_signal <= "000000000000000000000000";   
        else 
          filtered_signal <= std_logic_vector(sum srl 9);   
        end if; 
        state <= "11111"; 
      else 
        state <= "00000"; 
        start <= '0'; 
      end if; 
    end if; 
  end if; 
  end process;   
end behavior;