Library IEEE;  
USE IEEE.Std_logic_1164.all;   
USE IEEE.Std_logic_signed.all;   
use IEEE.NUMERIC_STD.all;

entity fir is
      generic(  
        input_width : integer :=12 ;
        coef_width : integer :=12 ;
        tap : integer :=9);
 port(  
      Din : in std_logic_vector(input_width-1 downto 0);
      Clk : in std_logic;
      reset : in std_logic;
      filter_type : in std_logic_vector(1 downto 0);
      Dout : out std_logic_vector (input_width+coef_width-1 downto 0));
 end fir;
 
 architecture behaivioral of fir is  
 


 signal Din_cov : signed (11 downto 0);
 
 type coeficient_type is array (0 to tap-1) of signed(coef_width-1 downto 0);
 -----------------------------------FIR filter coefficients----------------------------------------------------------------  
 signal coeficient: coeficient_type;                                         
 ----------------------------------------------------------------------------------------------                                     
 type shift_reg_type is array (0 to tap-1) of signed(input_width-1 downto 0);  
 signal shift_reg : shift_reg_type;  
 
 type mult_type is array (0 to tap-1) of signed(input_width+coef_width-1 downto 0);  
 signal mult : mult_type;  
 
 type ADD_type is array (0 to tap-1) of signed(input_width+coef_width-1 downto 0);  
 signal ADD: ADD_type;  
 
 begin  
 
 Din_cov <= signed(Din);
 
 --,Din_cov'length)

 -- type

    coeficient <=   
    (
    to_signed(-9,coef_width),     
    to_signed(-10,coef_width), 
    to_signed(20,coef_width), 
    to_signed(74,coef_width), 
    to_signed(102,coef_width), 
    to_signed(74,coef_width), 
    to_signed(20,coef_width), 
    to_signed(-10,coef_width),
    to_signed(-9,coef_width)
    ) 
    when filter_type = "00" else  --lowpass
    (
    to_signed(-27,coef_width),  
    to_signed(28,coef_width), 
    to_signed(33,coef_width), 
    to_signed(-70,coef_width), 
    to_signed(110,coef_width), 
    to_signed(-70,coef_width), 
    to_signed(33,coef_width), 
    to_signed(28,coef_width),
    to_signed(-27,coef_width)
    )
    when filter_type = "01" else  --highpass
    (
    to_signed(-6,coef_width),  
    to_signed(42,coef_width), 
    to_signed(76,coef_width), 
    to_signed(-40,coef_width), 
    to_signed(162,coef_width), 
    to_signed(-40,coef_width), 
    to_signed(76,coef_width), 
    to_signed(42,coef_width),
    to_signed(-6,coef_width)
    )
    when filter_type = "10" else --bandpass
    (
    to_signed(18,coef_width),  
    to_signed(52,coef_width), 
    to_signed(-52,coef_width), 
    to_signed(18,coef_width), 
    to_signed(67,coef_width), 
    to_signed(18,coef_width), 
    to_signed(-52,coef_width), 
    to_signed(52,coef_width),
    to_signed(18,coef_width)
    )
    when filter_type = "11";  --bandstop
 
        shift_reg(0)     <= Din_cov;  
        mult(0) <= Din_cov*coeficient(0);  
        ADD(0) <= Din_cov*coeficient(0);  
           GEN_FIR:  
           for i in 0 to tap-2 generate  
           begin  
                  process(Clk,reset)  
                  begin   
                       if (reset = '1') then  
                            shift_reg(i+1) <= (others => '0');  
                    elsif ( rising_edge(Clk) ) then  
                            shift_reg(i+1) <= shift_reg(i);   
                   end if;      
                  end process; 
                -- filter multiplication  
                mult(i+1)<= shift_reg(i+1)*coeficient(i+1);  
                -- filter conbinational addition  
                ADD(i+1)<=ADD(i)+mult(i+1);  
           end generate GEN_FIR;  
           Dout <= std_logic_vector(ADD(tap-1));
			  --to_signed(ADD(tap-1),Dout'length)
 
 end Architecture; 