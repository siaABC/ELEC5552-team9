Library IEEE;  
 USE IEEE.Std_logic_1164.all;   
 USE IEEE.Std_logic_signed.all;   
 
 entity FIR_RI2 is  -- VHDL projects
 generic (  
           input_width          : integer     :=8               ;-- set input width by user  
           output_width     : integer     :=16               ;-- set output width by user  
           coef_width          : integer     :=8               ;-- set coefficient width by user  
           tap                    : integer     :=11               ;-- set filter order  
           guard               : integer     :=0)               ;-- log2(tap)+1  
 port(  
      Din          : in      std_logic_vector(input_width-1 downto 0)     ;-- input data  
      Clk          : in      std_logic                                             ;-- input clk  
      reset     : in      std_logic                                             ;-- input reset  
      Dout     : out      std_logic_vector(output_width-1 downto 0))     ;-- output data  
 end entity;


 
 architecture behaivioral of FIR_RI2 is  
 
 type Coeficient_type is array (0 to tap-1) of std_logic_vector(coef_width-1 downto 0);  
 -----------------------------------FIR filter coefficients----------------------------------------------------------------  
 constant coeficient: coeficient_type :=   
                               (     X"F1",  
                                     X"F3",  
                                     X"07",  
                                     X"26",  
                                     X"42",  
                                     X"4E",  
                                     X"42",  
                                     X"26",  
                                     X"07",  
                                     X"F3",  
                                     X"F1"                                     
                                    );    
										
								
						
	type shift_reg_type is array (0 to tap-1) of std_logic_vector(input_width-1 downto 0);  
   signal shift_reg : shift_reg_type;  		
	type mult_type is array (0 to tap-1) of std_logic_vector(input_width+coef_width-1 downto 0);  
   signal mult : mult_type;
   type ADD_type is array (0 to tap-2) of std_logic_vector(input_width+coef_width-1 downto 0);  
   signal ADD: ADD_type; 
	
	component N_bit_Reg   
   generic (  
           input_width          : integer     :=8  
           );  
   port( 
    D :in std_logic_vector(input_width-1 downto 0)	;     
    Clk :in std_logic;    
    reset :in std_logic;   
    Q : out std_logic_vector(input_width-1 downto 0));  
	
	end component;


	 
	 
	begin 
	
	 R0  : N_bit_Reg port map  (shift_reg(0),clk,reset,shift_reg(1));	
    R1  : N_bit_Reg port map  (shift_reg(1),clk,reset,shift_reg(2)); 
	 R2  : N_bit_Reg port map  (shift_reg(2),clk,reset,shift_reg(3));
	 R3  : N_bit_Reg port map  (shift_reg(3),clk,reset,shift_reg(4));
	 R4  : N_bit_Reg port map  (shift_reg(4),clk,reset,shift_reg(5));
	 R5  : N_bit_Reg port map  (shift_reg(5),clk,reset,shift_reg(6));
	 R6  : N_bit_Reg port map  (shift_reg(6),clk,reset,shift_reg(7));
	 R7  : N_bit_Reg port map  (shift_reg(7),clk,reset,shift_reg(8));
	 R8  : N_bit_Reg port map  (shift_reg(8),clk,reset,shift_reg(9));
	 R9  : N_bit_Reg port map  (shift_reg(9),clk,reset,shift_reg(10));
    
	 shift_reg(0)     <= Din;  
    mult(0)<= Din*coeficient(0);
	 mult(1)<= shift_reg(1)*coeficient(1);
	 ADD(0) <= mult(0)+mult(1); 
	 
	 
	 
	   
    mult(2)<= shift_reg(2)*coeficient(2);
	 ADD(1) <= mult(2)+ADD(0); 
	 
	 
	 
	 mult(3)<= shift_reg(3)*coeficient(3);
	 ADD(2) <= mult(3)+ADD(1); 
	 
	 
	 
	 mult(4)<= shift_reg(4)*coeficient(4);
	 ADD(3) <= mult(4)+ADD(2); 
	 
	 
	 
	 mult(5)<= shift_reg(5)*coeficient(5);
	 ADD(4) <= mult(5)+ADD(3); 
	 

	 
	 mult(6)<= shift_reg(6)*coeficient(6);
	 ADD(5) <= mult(6)+ADD(4); 
	 
	 
	 
	 mult(7)<= shift_reg(7)*coeficient(7);
	 ADD(6) <= mult(7)+ADD(5); 
	 
	 
	 
	 mult(8)<= shift_reg(8)*coeficient(8);
	 ADD(7) <= mult(8)+ADD(6); 
	 
	 
	 
	 mult(9)<= shift_reg(9)*coeficient(9);
	 ADD(8) <= mult(9)+ADD(7); 
	 
	 
	 
	 mult(10)<= shift_reg(10)*coeficient(10);
	 ADD(9) <= mult(10)+ADD(8); 
	 
	 
	 
	 --mult(11)<= shift_reg(11)*;
	 --ADD(10) <= mult(11)+ADD(9);
	 
	 Dout <= ADD(9);
	 
	 end behaivioral;
	
    	