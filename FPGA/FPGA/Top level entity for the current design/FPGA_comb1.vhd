library ieee;				
use ieee.std_logic_1164.all;


entity FPGA_comb1 is 
  port (clk_in : in std_logic;
      reset : in std_logic;
		sel   : in std_logic_vector(3 downto 0);
		clk_switch : in std_logic;
		original_signal : in std_logic_vector(11 downto 0);
		filtered_signal : out std_logic_vector(23 downto 0);
		out_7seg : out std_logic_vector(6 downto 0));
end entity;

architecture v1 of FPGA_comb1 is

 signal clk_transfer : std_logic;

 component mockclk
 Port ( 
	       clk_in : in STD_LOGIC; 
	        clk_reset : in STD_LOGIC;
			 clk_switch : in STD_LOGIC;  
			 clk_out : out STD_LOGIC
			 --clk_out: out STD_LOGIC
			  
          );
			 
			 end component;
			 
 component mock7seg
 Port ( 
	       SW : in STD_LOGIC_VECTOR (3 downto 0);
			 HEX0 : out std_logic_vector (6 downto 0)
			 --clk_out: out STD_LOGIC
			  
          );
			 end component;
			 
 component FIR_filter is 
  port(clk : in std_logic; 
       reset : in std_logic; 
             original_signal : in std_logic_vector(11 downto 0); 
       filtered_signal : out std_logic_vector(23 downto 0)); 
          end component;
			 
			 begin
			 
	U1: mockclk    port map (clk_in,reset,clk_switch,clk_transfer);
	U2: mock7seg   port map (sel,out_7seg);
	U3: FIR_filter port map (clk_transfer,reset,original_signal,filtered_signal);
	
	end v1;
			 
			 