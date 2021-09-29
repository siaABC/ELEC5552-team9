--N_bit register for the filter

Library IEEE;  
 USE IEEE.Std_logic_1164.all; 

entity N_bit_Reg is   
 generic (  
           input_width          : integer     :=8  
           );  
   port(  
    Q : out std_logic_vector(input_width-1 downto 0);    
    Clk :in std_logic;    
    reset :in std_logic;  
    D :in std_logic_vector(input_width-1 downto 0)    
   );  
 end N_bit_Reg;  
  
 architecture Behavioral of N_bit_Reg is   
 begin   
      process(Clk,reset)  
      begin   
           if (reset = '1') then  
                Q <= (others => '0');  
        elsif ( rising_edge(Clk) ) then  
                Q <= D;   
       end if;      
      end process;   
 end Behavioral;