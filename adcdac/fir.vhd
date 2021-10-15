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
      Dout : out std_logic_vector(input_width-1 downto 0);
		Dout2: out std_logic_vector(input_width+coef_width-1 downto 0)
		);
 end fir;
 
 architecture behaivioral of fir is  
 
-- component N_bit_Reg   
-- generic (  
--           input_width          : integer     :=8  
--           );  
--   port(  
--    Q : out signed(input_width-1 downto 0);     
--    Clk :in std_logic;    
--    reset :in std_logic;   
--    D :in signed(input_width-1 downto 0)    
--   );  
-- end component;
 
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
 
 -- convert input and output
 signal Din_converted : signed(input_width-1 downto 0);
 signal Dout_converted: signed(input_width+coef_width-1 downto 0);
-- signal temp : std_logic_vector(input_width+coef_width-1 downto 0);
 signal temp1 : integer;
 signal temp2 : integer;
-- signal temp3 : integer;
-- signal temp4 : integer;
-- signal temp5 : signed (input_width-1 downto 0);



 
 begin  
 
 -- signal convertion
 Din_converted <= signed(Din);
-- temp3 <= to_integer(Din_converted);
-- temp4 <= temp3 * 256;
-- temp5 <= to_signed(temp4, temp5'length);
 temp1 <= to_integer(Dout_converted);
 temp2 <= temp1/256;
 Dout <= std_logic_vector(to_signed(temp2, Dout'length));
-- temp   <= std_logic_vector(Dout_converted);
-- Dout   <= temp (input_width+coef_width-1 downto coef_width);
 Dout2 <= std_logic_vector(Dout_converted);
 
 -- type

    coeficient <=   
    (
--    to_signed(-9,coef_width),     
--    to_signed(-10,coef_width), 
--    to_signed(20,coef_width), 
--    to_signed(74,coef_width), 
--    to_signed(102,coef_width), 
--    to_signed(74,coef_width), 
--    to_signed(20,coef_width), 
--    to_signed(-10,coef_width),
--    to_signed(-9,coef_width)

    to_signed(27,coef_width),  
    to_signed(-28,coef_width), 
    to_signed(-33,coef_width), 
    to_signed(70,coef_width), 
    to_signed(-110,coef_width), 
    to_signed(70,coef_width), 
    to_signed(-33,coef_width), 
    to_signed(-28,coef_width),
    to_signed(27,coef_width)
    ) 
    when filter_type = "00" else     --lowpass
    (
    to_signed(6,coef_width),  
    to_signed(-17,coef_width), 
    to_signed(33,coef_width), 
    to_signed(-46,coef_width), 
    to_signed(52,coef_width), 
    to_signed(-46,coef_width), 
    to_signed(33,coef_width), 
    to_signed(-17,coef_width),
    to_signed(6,coef_width)

--    to_signed(-27,coef_width),  
--    to_signed(28,coef_width), 
--    to_signed(33,coef_width), 
--    to_signed(-70,coef_width), 
--    to_signed(110,coef_width), 
--    to_signed(-70,coef_width), 
--    to_signed(33,coef_width), 
--    to_signed(28,coef_width),
--    to_signed(-27,coef_width)
    )
    when filter_type = "01" else     --highpass
    (
--    to_signed(-6,coef_width),  
--    to_signed(42,coef_width), 
--    to_signed(76,coef_width), 
--    to_signed(-40,coef_width), 
--    to_signed(162,coef_width), 
--    to_signed(-40,coef_width), 
--    to_signed(76,coef_width), 
--    to_signed(42,coef_width),
--    to_signed(-6,coef_width)

    to_signed(7,coef_width),  
    to_signed(-43,coef_width), 
    to_signed(-76,coef_width), 
    to_signed(40,coef_width), 
    to_signed(94,coef_width), 
    to_signed(40,coef_width), 
    to_signed(-76,coef_width), 
    to_signed(-43,coef_width),
    to_signed(7,coef_width)
    )
    when filter_type = "10" else      --bandpass
    (
--    to_signed(18,coef_width),  
--    to_signed(52,coef_width), 
--    to_signed(-52,coef_width), 
--    to_signed(18,coef_width), 
--    to_signed(67,coef_width), 
--    to_signed(18,coef_width), 
--    to_signed(-52,coef_width), 
--    to_signed(52,coef_width),
--    to_signed(18,coef_width)

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
    when filter_type = "11";          --bandstop
 
        shift_reg(0)     <= Din_converted;  
        mult(0) <= Din_converted*coeficient(0);  
        ADD(0) <= Din_converted*coeficient(0);  
           GEN_FIR:  
           for i in 0 to tap-2 generate  
           begin  
                 -- N-bit reg unit  
--                 N_bit_Reg_unit : N_bit_Reg generic map (input_width => 8)   
--                 port map ( Clk => Clk,   
--                            reset => reset,  
--                            D => shift_reg(i),  
--                            Q => shift_reg(i+1)  
--                            ); 
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
           Dout_converted <= ADD(tap-1); 
 
 end Architecture; 
