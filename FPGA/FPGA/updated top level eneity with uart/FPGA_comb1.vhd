library ieee;				
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity FPGA_comb1 is 
  port (clk_in : in std_logic;
      reset : in std_logic;
		sel   : in std_logic_vector(3 downto 0);
		clk_switch : in std_logic;
		original_signal : in std_logic_vector(11 downto 0);
		filtered_signal : out std_logic_vector(23 downto 0);
		out_7seg : out std_logic_vector(6 downto 0);
		
	 --resetb : in std_logic;
	 txdbuf : in std_logic_vector(7 downto 0):="11001010";
	 xmit_cmd_p : in std_logic;
	 rxdr:in std_logic;
	 txd : out std_logic;
	 txd_done : out std_logic;
	 r_ready:out std_logic;
	 rbuf:out std_logic_vector(7 downto 0)
		
		
		);
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
			 
component uart is 
 port ( 
    clk : in std_logic;
    resetb : in std_logic;
	 --connected to main clk and reset
	 txdbuf : in std_logic_vector(7 downto 0):="11001010";
	 xmit_cmd_p : in std_logic;
	 rxdr:in std_logic;
	 txd : out std_logic;
	 txd_done : out std_logic;
	 r_ready:out std_logic;
	 rbuf:out std_logic_vector(7 downto 0));
	 end component;
			 
			 begin
			 
	U1: mockclk    port map (clk_in,reset,clk_switch,clk_transfer);
	U2: mock7seg   port map (sel,out_7seg);
	U3: FIR_filter port map (clk_transfer,reset,original_signal,filtered_signal);
	U4: uart       port map (clk_in,reset,txdbuf,xmit_cmd_p,rxdr,txd,txd_done,r_ready,rbuf);
	
	end v1;
			 
			 