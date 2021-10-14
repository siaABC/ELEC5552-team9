library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity uart is
port(clk_in:in std_logic;
      rx:in std_logic;
      tx:out std_logic;
      tcmd:in std_logic;
      tx_done:out std_logic;
      rx_ready:out std_logic;
	  tx_available:out std_logic;
      t_data:in std_logic_vector(7 downto 0);
      r_data:out std_logic_vector(7 downto 0));
end uart;
architecture beheavior of uart is
component baud is
port(clk:in std_logic;
     bclk:out std_logic);
end component;

component rxd is
port(bclk_in,rxd_in:in std_logic;
      rx_ready:out std_logic;
      rx_buffer:out std_logic_vector(7 downto 0));
end component;

component txd is
port(bclk_in:in std_logic;
      tx_cmd:in std_logic;
      txd_out:out std_logic;
      txd_done:out std_logic;
	  tx_available:out std_logic;
      tx_buffer:in std_logic_vector(7 downto 0));
end component;

signal baud_clk:std_logic;
begin
B:baud 
port map(clk_in,baud_clk);
R:rxd
port map(baud_clk,rx,rx_ready,r_data);
T:txd
port map(baud_clk,tcmd,tx,tx_done,tx_available,t_data);
end beheavior;