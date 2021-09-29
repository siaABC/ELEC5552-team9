library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity reciever is
generic(framlenr:integer:=8);	         
Port(
	bclkr,resetr,rxdr:in std_logic;                       --������������ź�
	r_ready:out std_logic;
	rbuf:out std_logic_vector(7 downto 0)
	);
end reciever;
architecture behave of reciever is
type states is (r_start,r_center,r_wait,r_sample,r_stop);            --�������״̬
signal state:states:=r_start;
signal rxd_sync:std_logic;
	begin
	pro1:process(rxdr)
	begin
		if rxdr='0' then 
			rxd_sync<='0';
		else 
			rxd_sync<='1';
		end if;
end process;

	pro2:process(bclkr,resetr,rxd_sync)                            --����ʱ����Ͻ���
	variable count:std_logic_vector(3 downto 0);                    --�����м����
	variable rcnt:integer:=0;
	variable rbufs:std_logic_vector(7 downto 0);
	begin
		if resetr='1' then 
			state <= r_start; 
			count := "0000";                --��λ
		elsif rising_edge(bclkr) then
			case state is
				when r_start =>	--״̬1���ȴ���ʼλ
					if rxd_sync='0' then 
						state <= r_center; 
						r_ready <= '0'; 
						rcnt := 0;
					else 
						state <= r_start; 
						r_ready <= '0';
					end if;                              
				when r_center =>	--״̬2�����ÿλ���е�
					if rxd_sync='0' then
						if count="0100" then 
							state <= r_wait; 
							count := "0000";
						else 
							count := count+1; 
							state <= r_center;
						end if;
					else 
						state <= r_start;
					end if;                            
				when r_wait => 	--״̬3���ȴ�״̬
					if count >= "1110" then
						if rcnt=framlenr then 
							state <= r_stop;
						else 
							state <= r_sample;
						end if;
						count := "0000";                    
					else 
						count := count+1; 
						state <= r_wait;
					end if;
				when r_sample =>
					rbufs(rcnt) := rxd_sync; 
					rcnt := rcnt+1;
					state <= r_wait;	--״̬4������λ�������
				when r_stop =>
					r_ready <= '1'; 
					rbuf <= rbufs; 
					state <= r_start; --״̬4�����֡��������ź�
				when others =>
					state <= r_start;
			end case;
		end if;
	end process;
end behave;
