library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity baud is
Port(
	clk : in std_logic;
	resetb : in std_logic;
	bclk   : out std_logic 
	);
end baud;

architecture behave of baud is
begin
	process(clk,resetb)
	variable cnt:integer;
	begin
		if resetb = '1' then 
			cnt := 0; 
			bclk <= '0';	--��λ
		elsif rising_edge(clk) then
			if cnt >= 208 then 
				cnt := 0; 
				bclk <= '1';	--���÷�Ƶϵ��
			else 
				cnt := cnt+1; 
				bclk <= '0';
			end if;
		end if;
	end process;
end behave;
