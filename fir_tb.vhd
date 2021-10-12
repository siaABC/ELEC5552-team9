library ieee;  
use ieee.std_logic_1164.all;  
use STD.TEXTIO.all; 
use ieee.STD_LOGIC_TEXTIO.all;
use IEEE.NUMERIC_STD.all;

entity fir_tb is   
end fir_tb;  

architecture rtl of fir_tb is  
component fir  
    generic(  
        input_width : integer :=12 ;
        coef_width : integer :=12 ;
        tap : integer :=9);
	port(  
		clk,reset :in std_logic;
		din :in signed(input_width-1 downto 0);
		filter_type :in std_logic_vector(1 downto 0);
		dout  :out  signed(input_width+coef_width-1 downto 0)
	);
end component;  

	signal clk  :std_logic:='0';
	signal rstp :std_logic:='1';
	signal din  :signed(11 downto 0);
	signal dout :signed(23 downto 0);
	signal filter_type :std_logic_vector(1 downto 0); 
    constant clk_period :time :=20 ns; 
	signal file_open_flag  :std_logic:='0';
  
begin
 
fir_i:fir 
port map(  
	clk=>clk,
	reset=>rstp,
	din=>din,
	filter_type=>filter_type,
	dout=>dout
	);  


  clk_gen:process  
  begin      
    wait for clk_period/2;  
    clk<='1';   
    wait for clk_period/2;  
    clk<='0';  
  end process;  
  
  rst_gen:process  
  begin        
    rstp<='1';   
    wait for clk_period*2;  
    rstp<='0';   
	wait;  
  end process; 

  filter_type_gen:process  
  begin  
    filter_type<="00";  
    wait for clk_period*100;
    filter_type<="01"; 
    wait for clk_period*100;
    filter_type<="10"; 
    wait for clk_period*100;
    filter_type<="11"; 
    wait;  
  end process;  



read_process : process(clk)
	variable i : integer:= 0;
	file FILE_IN  : TEXT;
	variable LINE_IN: line;
	variable data : std_logic_vector(11 downto 0);
begin
	if(rstp='1' and file_open_flag = '0')then
		file_open(FILE_IN, "mem1.txt", READ_MODE);
		file_open_flag <= '1';
	elsif(rising_edge(clk)) then
		readline(FILE_IN, LINE_IN);
		read(LINE_IN, data); 
		din <= signed(data);
	end if;
end process;

 

end rtl;  