library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity uart is 
 port ( 
    clk : in std_logic;
    resetb : in std_logic;
	 txdbuf : in std_logic_vector(7 downto 0):="11001010";
	 xmit_cmd_p : in std_logic;
	 rxdr:in std_logic;
	 txd : out std_logic;
	 txd_done : out std_logic;
	 r_ready:out std_logic;
	 rbuf:out std_logic_vector(7 downto 0));
	 end entity;
	 
architecture v5 of uart is

   component baud is
Port(
	clk : in std_logic;
	resetb : in std_logic;
	bclk   : out std_logic 
	);
end component;

component transfer is
generic(framlent:integer:=8);
Port(
	bclkt,resett,xmit_cmd_p : in std_logic;	
	txdbuf : in std_logic_vector(7 downto 0):="11001010";
	txd : out std_logic;
	txd_done : out std_logic
	);
end component;

component reciever is
generic(framlenr:integer:=8);	         
Port(
	bclkr,resetr,rxdr:in std_logic;                       
	r_ready:out std_logic;
	rbuf:out std_logic_vector(7 downto 0)
	);
end component;

signal bclk_transfer : std_logic;

begin

 Ua1: baud     port map (clk,resetb,bclk_transfer);
 Ua2: transfer port map (bclk_transfer,resetb,xmit_cmd_p,txdbuf,txd,txd_done);
 Ua3: reciever port map (bclk_transfer,resetb,rxdr,r_ready,rbuf);
 
 end v5;
