library ieee;  
use ieee.std_logic_1164.all;  
use IEEE.NUMERIC_STD.all;

entity uart_top_tb is   
end uart_top_tb;  

architecture rtl of uart_top_tb is  
component uart_top  
	port(clk_in:in std_logic;
		  rx:in std_logic;
		  tx:out std_logic;
		  tx_en:in std_logic;
		  data:in std_logic_vector(23 downto 0)
		  );
end component;  

	signal clk_in  :std_logic:='0';
	signal rx :std_logic:='1';
	signal tx :std_logic:='1';
	signal tx_en :std_logic:='0';
	signal data :std_logic_vector(23 downto 0):=x"a53f96"; 
	
    constant clk_period :time :=20 ns; 
  
begin

uart_top_i:uart_top 
port map(  
	clk_in=>clk_in,
	rx=>rx,
	tx=>tx,
	tx_en=>tx_en,
	data=>data
	);  


  clk_gen:process  
  begin      
    wait for clk_period/2;  
    clk_in<='1';   
    wait for clk_period/2;  
    clk_in<='0';  
  end process;  
  
  tx_en_gen:process  
  begin        
    tx_en<='0';   
    wait for clk_period*4;  
    tx_en<='1';   
	wait for clk_period; 
    tx_en<='0'; 
	wait;  
  end process; 


end rtl;  