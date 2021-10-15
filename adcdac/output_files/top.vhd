LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity top is
port
(
		ADC_CLK_10 			: in std_logic;
		MAX10_CLK1_50		: in std_logic;
		MAX10_CLK2_50		: in std_logic;


		KEY		: in std_logic_vector(1 downto 0);
		SW		: in std_logic_vector(9 downto 0);

		LEDR		: out std_logic_vector(9 downto 0);

		HEX0		: out std_logic_vector(7 downto 0);
		HEX1		: out std_logic_vector(7 downto 0);
		HEX2		: out std_logic_vector(7 downto 0);
		HEX3		: out std_logic_vector(7 downto 0);
		HEX4		: out std_logic_vector(7 downto 0);
		HEX5		: out std_logic_vector(7 downto 0);

		DRAM_CLK		: out std_logic;
		DRAM_CKE		: out std_logic;
		DRAM_ADDR		: out std_logic_vector(12 downto 0);
		DRAM_BA		: out std_logic_vector(1 downto 0);
		DRAM_DQ		: inout std_logic_vector(15 downto 0);
		DRAM_LDQM		: out std_logic;
		DRAM_UDQM		: out std_logic;
		DRAM_CS_N		: out std_logic;
		DRAM_WE_N		: out std_logic;
		DRAM_CAS_N		: out std_logic;
		DRAM_RAS_N		: out std_logic;


 		VGA_HS		: out std_logic;
		VGA_VS		: out std_logic;
		VGA_R		: out std_logic_vector(3 downto 0);
		VGA_G		: out std_logic_vector(3 downto 0);
		VGA_B		: out std_logic_vector(3 downto 0);


 		CLK_I2C_SCL		: out std_logic;
 		CLK_I2C_SDA		: inout std_logic;

 		GSENSOR_SCLK		: out std_logic;
 		GSENSOR_SDO		: inout std_logic;
 		GSENSOR_SDI		: inout std_logic;
 		GSENSOR_INT		: inout std_logic_vector(3 downto 0);
 		GSENSOR_CS_N		: out std_logic;



 		GPIO		: inout std_logic_vector(35 downto 0);
 		ARDUINO_IO		: inout std_logic_vector(15 downto 0);
 		ARDUINO_RESET_N		: inout std_logic

);
end top;

ARCHITECTURE behavior OF top IS

   component uart_top is
port(clk_in:in std_logic;
      rx:in std_logic;
      tx:out std_logic;
	  tx_en:in std_logic;
	  data:in std_logic_vector(23 downto 0)
	  );
end component;

   component mock7seg is 
  

	 Port ( 
	       SW : in STD_LOGIC_VECTOR (1 downto 0);
			 HEX0 : out std_logic_vector (6 downto 0)
			 --clk_out: out STD_LOGIC
			  
          );
			 
   end component;

   component fir is
    generic(  
        input_width : integer :=12 ;
        coef_width : integer :=12 ;
        tap : integer :=9);
 port(  
      Din : in std_logic_vector(input_width-1 downto 0);
      Clk : in std_logic;
      reset : in std_logic;
      filter_type : in std_logic_vector(1 downto 0);
      Dout : out std_logic_vector(coef_width-1 downto 0);
		Dout2: out std_logic_vector(input_width+coef_width-1 downto 0)
		);
 end component;

	component DE10_Lite is
	port
	(

			ADC_CLK_10 			: in std_logic;
			MAX10_CLK1_50		: in std_logic;
			MAX10_CLK2_50		: in std_logic;


			KEY		: in std_logic_vector(1 downto 0);
			SW		: in std_logic_vector(9 downto 0);

			LEDR		: out std_logic_vector(9 downto 0);

			HEX0		: out std_logic_vector(7 downto 0);
			HEX1		: out std_logic_vector(7 downto 0);
			HEX2		: out std_logic_vector(7 downto 0);
			HEX3		: out std_logic_vector(7 downto 0);
			HEX4		: out std_logic_vector(7 downto 0);
			HEX5		: out std_logic_vector(7 downto 0);

			DRAM_CLK		: out std_logic;
			DRAM_CKE		: out std_logic;
			DRAM_ADDR		: out std_logic_vector(12 downto 0);
			DRAM_BA		: out std_logic_vector(1 downto 0);
			DRAM_DQ		: inout std_logic_vector(15 downto 0);
			DRAM_LDQM		: out std_logic;
			DRAM_UDQM		: out std_logic;
			DRAM_CS_N		: out std_logic;
			DRAM_WE_N		: out std_logic;
			DRAM_CAS_N		: out std_logic;
			DRAM_RAS_N		: out std_logic;


			VGA_HS		: out std_logic;
			VGA_VS		: out std_logic;
			VGA_R		: out std_logic_vector(3 downto 0);
			VGA_G		: out std_logic_vector(3 downto 0);
			VGA_B		: out std_logic_vector(3 downto 0);


			CLK_I2C_SCL		: out std_logic;
			CLK_I2C_SDA		: inout std_logic;

			GSENSOR_SCLK		: out std_logic;
			GSENSOR_SDO		: inout std_logic;
			GSENSOR_SDI		: inout std_logic;
			GSENSOR_INT		: inout std_logic_vector(3 downto 0);
			GSENSOR_CS_N		: out std_logic;



			GPIO		: inout std_logic_vector(35 downto 0);
			ARDUINO_IO		: inout std_logic_vector(15 downto 0);
			ARDUINO_RESET_N		: inout std_logic;
			sys_clk_out			:	out std_logic;
			
			adc_data_out		: out std_logic_vector(11 downto 0);
			adc_data_out_valid : out std_logic
	);
end component;

	component pmod_dac2 is
	generic
	(
		  clk_freq    : INTEGER := 25;  --system clock frequency in MHz
		  spi_clk_div : INTEGER := 1
   );  --spi_clk_div = clk_freq/60 (answer rounded up));
	port
	(
		  clk        : IN      STD_LOGIC;                      --system clock
		  reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
		  dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DACs
		  dac_data_a : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC A
		  dac_data_b : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC B
		  busy       : OUT     STD_LOGIC;                      --indicates when transactions with DACs can be initiated
		  mosi_a     : OUT     STD_LOGIC;                      --SPI bus to DAC A: master out, slave in (DIN A)
		  mosi_b     : OUT     STD_LOGIC;                      --SPI bus to DAC B: master out, slave in (DIN B)
		  sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
		  ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0) --SPI bus to DAC: slave select (~SYNC)
	);
	end component;
	
	signal clk				: std_logic:='0';
	signal ResetN				: std_logic:='0';
	signal ResetCnt			: std_logic_vector(15 downto 0) :=(others => '0');
	signal DacDataIn1			: std_logic_vector(11 downto 0) :=(others => '0');
	signal DacDataIn2			: std_logic_vector(11 downto 0) :=(others => '0');
	signal led 					: std_logic_vector(9 downto 0) :=(others => '0');
	signal AdcData 			: std_logic_vector(11 downto 0) :=(others => '0');
	signal AdcDataD 			: std_logic_vector(11 downto 0) :=(others => '0');
	signal AdcDataValid		: std_logic:='0';
	signal AdcData_transfer : std_logic_vector(11 downto 0) :=(others => '0');
	signal output_filter_24 : std_logic_vector(23 downto 0);

begin
	LEDR(9)						<= clk;
	LEDR(8)						<= AdcDataValid;
	LEDR(6)						<= ResetN;
	LEDR(5)						<= ARDUINO_IO(13);
	
	
	ARDUINO_IO(8 downto 0)	<= (others => '0');

	process(MAX10_CLK1_50)
	begin
		if rising_edge(MAX10_CLK1_50) then
			if ResetCnt(15) = '1' then
				ResetN			<= '1';
			else
				ResetCnt			<= ResetCnt + 1;
			end if;
	
		end if;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk)then
			if ResetN = '0' then
				DacDataIn1 		<=	(others => '0');
				DacDataIn2		<=	(others => '0');

			else
				if AdcDataValid = '1' then
					DacDataIn1 			<=	AdcData_transfer;
					DacDataIn2 			<=	DacDataIn2 + 1;
					
				else
					DacDataIn1 			<=	DacDataIn1;
					DacDataIn2 			<=	DacDataIn2 + 1;
				end if;
				led 					<= DacDataIn2(9 downto 0);

			end if;
		
		end if;
	end process;
		


	DE10_Lite_inst: DE10_Lite 
	port map
	(

			ADC_CLK_10 			=>ADC_CLK_10,
			MAX10_CLK1_50 		=>MAX10_CLK1_50,
			MAX10_CLK2_50		=>MAX10_CLK2_50,


			KEY		=>KEY,
			SW		=>SW,

			LEDR		=>open,

			HEX0		=>HEX0,
			HEX1		=>HEX1,
			HEX2		=>HEX2,
			HEX3		=>HEX3,
			HEX4		=>HEX4,
--			HEX5		=>HEX5,

			DRAM_CLK		=>DRAM_CLK,
			DRAM_CKE		=>DRAM_CKE,
			DRAM_ADDR		=>DRAM_ADDR,
			DRAM_BA		=>DRAM_BA,
			DRAM_DQ		=>DRAM_DQ,
			DRAM_LDQM		=>DRAM_LDQM,
			DRAM_UDQM		=>DRAM_UDQM,
			DRAM_CS_N		=>DRAM_CS_N,
			DRAM_WE_N		=>DRAM_WE_N,
			DRAM_CAS_N		=>DRAM_CAS_N,
			DRAM_RAS_N		=>DRAM_RAS_N,


			VGA_HS		=>VGA_HS,
			VGA_VS		=>VGA_VS,
			VGA_R		=>VGA_R,
			VGA_G		=>VGA_G,
			VGA_B		=>VGA_B,


			CLK_I2C_SCL		=>CLK_I2C_SCL,
			CLK_I2C_SDA		=>CLK_I2C_SDA,

			GSENSOR_SCLK	=>GSENSOR_SCLK,
			GSENSOR_SDO		=>GSENSOR_SDO,
			GSENSOR_SDI		=>GSENSOR_SDI,
			GSENSOR_INT		=>GSENSOR_INT,
			GSENSOR_CS_N	=>GSENSOR_CS_N,



			GPIO		=>GPIO,
			ARDUINO_IO		=>open,
			ARDUINO_RESET_N		=>ARDUINO_RESET_N,
			sys_clk_out		=> clk,
			
			adc_data_out	=> AdcData,
			adc_data_out_valid => AdcDataValid
	);
	
	pmod_dac2_inst : pmod_dac2
	port map
	(
		  clk        => clk,                      --system clock
		  reset_n    => ResetN,                      --active low asynchronous reset
		  dac_tx_ena => '1',                      --enable transaction with DACs
		  dac_data_a => DacDataIn1,  --data value to send to DAC A
		  dac_data_b => DacDataIn2,  --data value to send to DAC B
		  busy       => open,                      --indicates when transactions with DACs can be initiated
		  mosi_a     => ARDUINO_IO(11),                      --SPI bus to DAC A: master out, slave in (DIN A)
		  mosi_b     => ARDUINO_IO(12),                      --SPI bus to DAC B: master out, slave in (DIN B)
		  sclk       => ARDUINO_IO(13),                      --SPI bus to DAC: serial clock (SCLK)
		  ss_n(0)       => ARDUINO_IO(10)  --SPI bus to DAC: slave select (~SYNC)	
	);
	
	fir_inst : fir 
	port map
	(
	     Din        => AdcData,
		  Clk        => clk,
		  reset      => ResetN,
		  filter_type=> SW  (9 downto 8),
	     Dout       => AdcData_transfer,
		  Dout2      => output_filter_24
	);
	
	inst_7seg : mock7seg
	port map
	(SW(9 downto 8),HEX5(6 downto 0));
	
	inst_usb  : uart_top
	port map
	(clk,'1',ARDUINO_IO(9),'0',output_filter_24);
	     

end behavior;


