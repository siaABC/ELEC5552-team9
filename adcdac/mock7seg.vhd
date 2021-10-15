library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 entity mock7seg is 
  

	 Port ( 
	       SW : in STD_LOGIC_VECTOR (1 downto 0);
			 HEX0 : out std_logic_vector (6 downto 0)
			 --clk_out: out STD_LOGIC
			  
          );
			 
   end entity;
			 
	architecture v3 of mock7seg is 

	begin 
	
	decode7seg: process(SW)
	begin
   case SW is
   when "00" => HEX0 <="1000000";
   when "01" => HEX0 <="1111001";
   when "10" => HEX0 <="0100100";
   when "11" => HEX0 <="0110000";
   when others => HEX0 <="1111111";
	
	end case;
   end process decode7seg;
	
	end architecture;
              
	