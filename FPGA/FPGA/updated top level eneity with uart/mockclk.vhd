library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 entity mockclk is 
  
  generic(Freq_in : integer := 50000000); -- 50MHz clock on DE-10 Lite FPGA board
                             --50000000
	 Port ( 
	       clk_in : in STD_LOGIC; 
	        clk_reset : in STD_LOGIC;
			 clk_switch : in STD_LOGIC;  
			 clk_out : out STD_LOGIC
			 --clk_out: out STD_LOGIC
			  
          );
			 
			 end entity;
	architecture v2 of mockclk is 


	
	--clk
	signal temp: STD_LOGIC;--clk signal
   signal counter : integer; 
   constant N1 : integer:=2; -- 1HZ 
	constant N2 : integer:=4; -- 2HZ
	
	
	
	begin
	
	--clk
	frequency_divider: process (clk_reset, clk_in) 
		      begin 
				   if (clk_reset = '1') then
                    temp <= '0';
                    counter <= 0;
               elsif rising_edge(clk_in) then
					
					--1HZ
					 if (clk_switch = '1') then
                  if (counter >= Freq_in/N1) then 
					     	 temp <= NOT(temp); 
						    counter <= 0;
                   else
                      counter <= counter + 1; 
                   end if;
						 
						 --2HZ
						 elsif  (clk_switch = '0') then
						 if (counter >= Freq_in/N2) then 
					     	 temp <= NOT(temp); 
						    counter <= 0;
                   else
                      counter <= counter + 1; 
               end if; 
					end if;
					end if;
					end process;
					clk_out <= temp;
					
	
	end architecture;