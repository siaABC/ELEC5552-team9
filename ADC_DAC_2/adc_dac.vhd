library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity adc_dac is

--dac generic
 GENERIC(
    clk_freq    : INTEGER := 50;  --system clock frequency in MHz
    spi_clk_div : INTEGER := 1);  --spi_clk_div = clk_freq/60 (answer rounded up)

port ( 
    input : in std_logic;
	 clk   : in std_logic;
	 resetn: in std_logic;
	 filter_select: in std_logic_vector(1 downto 0);
	 output_buffer : out std_logic_vector(0 downto 0);
	 HEX0_out   : out std_logic_vector (6 downto 0);
	 output : out std_logic_vector (2 downto 0);
	 serialusb_out : out std_logic
	 



);
end entity;

ARCHITECTURE behavior OF adc_dac IS

signal shifted : std_logic_vector (11 downto 0);
signal tx_en_sig : std_logic;

--serial USB
component uart_top is
port(clk_in:in std_logic;
      rx:in std_logic;
      tx:out std_logic;
	  tx_en:in std_logic;
	  data:in std_logic_vector(23 downto 0)
	  );
end component;

--7seg
component mock7seg is 
  

	 Port ( 
	       SW : in STD_LOGIC_VECTOR (1 downto 0);
			 HEX0 : out std_logic_vector (6 downto 0)
			 --clk_out: out STD_LOGIC
			  
          );
			 
   end component;

--fir
component fir is


 port(  
      Din : in std_logic_vector(11 downto 0);
      Clk : in std_logic;
      reset : in std_logic;
      filter_type : in std_logic_vector(1 downto 0);
      Dout : out std_logic_vector(23 downto 0));
 end component;

--dac
component pmod_dac121S101 is
  GENERIC(
    clk_freq    : INTEGER := 50;  --system clock frequency in MHz
    spi_clk_div : INTEGER := 1);  --spi_clk_div = clk_freq/60 (answer rounded up)
  PORT(
    clk        : IN      STD_LOGIC;                      --system clock
    reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
    dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DACs
    dac_data_a : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC A
    dac_data_b : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC B
    busy       : OUT     STD_LOGIC;                      --indicates when transactions with DACs can be initiated
    mosi_a     : OUT     STD_LOGIC;                      --SPI bus to DAC A: master out, slave in (DIN A)
    mosi_b     : OUT     STD_LOGIC;                      --SPI bus to DAC B: master out, slave in (DIN B)
    sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
    ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0));  --SPI bus to DAC: slave select (~SYNC)
END component;

--adc
component adc_qsys is
	port (
		clk_clk                              : in  std_logic                     := '0';             --                      clk.clk
		clock_bridge_sys_out_clk_clk         : out std_logic;                                        -- clock_bridge_sys_out_clk.clk
		modular_adc_0_command_valid          : in  std_logic                     := '0';             --    modular_adc_0_command.valid
		modular_adc_0_command_channel        : in  std_logic_vector(4 downto 0)  := (others => '0'); --                         .channel
		modular_adc_0_command_startofpacket  : in  std_logic                     := '0';             --                         .startofpacket
		modular_adc_0_command_endofpacket    : in  std_logic                     := '0';             --                         .endofpacket
		modular_adc_0_command_ready          : out std_logic;                                        --                         .ready
		modular_adc_0_response_valid         : out std_logic;                                        --   modular_adc_0_response.valid
		modular_adc_0_response_channel       : out std_logic_vector(4 downto 0);                     --                         .channel
		modular_adc_0_response_data          : out std_logic_vector(11 downto 0);                    --                         .data
		modular_adc_0_response_startofpacket : out std_logic;                                        --                         .startofpacket
		modular_adc_0_response_endofpacket   : out std_logic;                                        --                         .endofpacket
		reset_reset_n                        : in  std_logic                     := '0'              --                    reset.reset_n
	);
end component;

signal command_valid : std_logic;
signal command_channel : std_logic_vector (4 downto 0);
signal startofpacket : std_logic;
signal endofpacket : std_logic;
signal reset_signal : std_logic;
signal adc_output  : std_logic_vector (11 downto 0);
signal empty_output : std_logic_vector (11 downto 0);
signal dac_input   : std_logic_vector (23 downto 0);


begin

U1 : adc_qsys PORT MAP (
          clk_clk => clk,
          modular_adc_0_command_valid => command_valid,
			 modular_adc_0_command_channel => command_channel,
			 modular_adc_0_command_startofpacket => startofpacket,
			 modular_adc_0_command_endofpacket => endofpacket,
			 reset_reset_n => reset_signal,
			 modular_adc_0_response_data => adc_output
			 );
			 
U2 : pmod_dac121S101 PORT MAP(
			 clk => clk,
			 reset_n => reset_signal,
			 dac_tx_ena => reset_signal,
			 dac_data_a => shifted,
			 dac_data_b => empty_output,
			 mosi_a => output(2),
			 mosi_b => output(1),
			 sclk => output(0),
			 ss_n => output_buffer
			 );
			 
filter: fir PORT MAP(adc_output,clk,resetn,filter_select,dac_input);

filter_display : mock7seg PORT MAP( filter_select,HEX0_out);

serialusb : uart_top PORT MAP(clk,'1',serialusb_out,'0',dac_input);

           
--set adc and dac			 
command_valid <='1';
command_channel <="00001";
startofpacket <='1';
endofpacket <='1';
reset_signal <='1';
empty_output <="000000000000";

shifted <= dac_input(23 downto 12);




end behavior;
			 
			 
			 

