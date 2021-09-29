library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity transfer is
generic(framlent:integer:=8);
Port(
	bclkt,resett,xmit_cmd_p : in std_logic;	--������������ź�
	txdbuf : in std_logic_vector(7 downto 0):="11001010";
	txd : out std_logic;
	txd_done : out std_logic
	);
end transfer;

architecture behave of transfer is
type states is (x_idle,x_start,x_wait,x_shift,x_stop);                --�������״̬
signal state:states := x_idle;
signal tcnt:integer:=0;
begin
	process(bclkt,resett,xmit_cmd_p,txdbuf)                         --����ʱ����Ͻ���
	variable xcnt16:std_logic_vector(4 downto 0) :="00000";            --�����м����
	variable xbitcnt:integer:=0;
	variable txds:std_logic;
	begin  
		if resett='1' then 
			state <= x_idle; 
			txd_done <= '0'; 
			txds := '1';           --��λ
		elsif rising_edge(bclkt) then
			case state is
				when x_idle =>	--״̬1���ȴ�����֡��������
					if xmit_cmd_p='1' then 
						state <= x_start;	
						txd_done <= '0';	
					else 
						state <= x_idle;               
					end if; 
				when x_start =>	--״̬2�������ź�����ʼλ
					if xcnt16 >= "01111" then 	
						state <= x_wait; 
						xcnt16 := "00000";
					else 
						xcnt16 := xcnt16+1; 
						txds := '0'; 
						state <= x_start;
					end if;                          
				when x_wait =>	--״̬3���ȴ�״̬
					if xcnt16 >= "01110" then
						if xbitcnt=framlent then 
							state <= x_stop; 
							xbitcnt := 0;
						else 
							state <= x_shift;
						end if;
						xcnt16 := "00000";
					else 
						xcnt16 := xcnt16+1; 
						state <= x_wait;
					end if;                    
				when x_shift =>
					txds := txdbuf(xbitcnt); 
					xbitcnt := xbitcnt+1; 
					state <= x_wait;				                                        --״̬4�����������ݽ��в���ת��
				when x_stop =>                         --״̬5��ֹͣλ����״̬
					if xcnt16 >= "01111" then
						if xmit_cmd_p='0' then 
							state <= x_idle; 
							xcnt16 := "00000";
						else 
							xcnt16 := xcnt16; 
							state <= x_stop;
						end if; 
						txd_done <= '1';
					else 
						xcnt16 := xcnt16+1; 
						txds := '1'; 
						state <= x_stop;
					end if;                      
				when others =>
					state <= x_idle;
			end case;		
		end if;
		txd <= txds;
	end process;
end behave;
