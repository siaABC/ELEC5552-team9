--uart_top

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity uart_top is
port(clk_in:in std_logic;
      rx:in std_logic;
      tx:out std_logic;
	  tx_en:in std_logic;
	  data:in std_logic_vector(23 downto 0)
	  );
end uart_top;

architecture beheavior of uart_top is

component uart is
port(clk_in:in std_logic;
      rx:in std_logic;
      tx:out std_logic;
      tcmd:in std_logic;
      tx_done:out std_logic;
      rx_ready:out std_logic;
	  tx_available:out std_logic;
      t_data:in std_logic_vector(7 downto 0);
      r_data:out std_logic_vector(7 downto 0));
end component;


signal tcmd:std_logic;
signal tx_done:std_logic;
signal rx_ready:std_logic;
signal t_data:std_logic_vector(7 downto 0);
signal r_data:std_logic_vector(7 downto 0);
signal state:std_logic_vector(2 downto 0);
signal tx_available:std_logic;

begin



process(clk_in)
begin
	if clk_in'event and clk_in='1' then
		case state is
			when "000" => 
				if tx_en = '1' then 
					t_data <= data(23 downto 16);
					state <= "001";
					tcmd <= '1';
				else
					t_data <= data(23 downto 16);
					state <= "000";
					tcmd <= '0';
				end if;
			when "001" =>
				if tx_done = '1'  then 
					t_data <= data(15 downto 8);
					state <= "010";
					tcmd <= '0';
				else
					t_data <= data(23 downto 16);
					state <= "001";
					tcmd <= '1';
				end if;
			when "010" =>
				if tx_available = '1'  then 
					t_data <= data(15 downto 8);
					state <= "011";
					tcmd <= '1';
				else
					t_data <= data(15 downto 8);
					state <= "010";
					tcmd <= '0';
				end if;
			when "011" =>
				if tx_done = '1'  then 
					t_data <= data(7 downto 0);
					state <= "100";
					tcmd <= '0';
				else
					t_data <= data(15 downto 8);
					state <= "011";
					tcmd <= '1';
				end if;
			when "100" =>
				if tx_available = '1'  then 
					t_data <= data(7 downto 0);
					state <= "101";
					tcmd <= '1';
				else
					t_data <= data(7 downto 0);
					state <= "100";
					tcmd <= '0';
				end if;
			when "101" =>
				if tx_done = '1'  then 
					t_data <= data(7 downto 0);
					state <= "110";
					tcmd <= '0';
				else
					t_data <= data(7 downto 0);
					state <= "101";
					tcmd <= '1';
				end if;
			when "110" =>
				if tx_available = '1'  then 
					t_data <= data(7 downto 0);
					state <= "000";
					tcmd <= '0';
				else
					t_data <= data(7 downto 0);
					state <= "110";
					tcmd <= '0';
				end if;
			when others=>state<="000";
		end case;
	end if;
end process;

uart_i:uart
port map(clk_in,rx,tx,tcmd,tx_done,rx_ready,tx_available,t_data,r_data);


end beheavior;