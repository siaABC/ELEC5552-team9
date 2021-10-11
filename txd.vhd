library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity txd is
    generic(data_bits:integer:=8);
    port(bclk_in:in std_logic;
         tx_cmd:in std_logic;
          txd_out:out std_logic;
          txd_done:out std_logic;
		  tx_available:out std_logic;
          tx_buffer:in std_logic_vector(7 downto 0));
end txd;
architecture beheavior of txd is
type states is(t_none,t_start,t_wait,t_shift,t_stop);
signal state:states:=t_none;
signal t_cnt:integer:=0;
signal tx_available_r:std_logic;
--variable count:std_logic_vector(4 downto 0):="00000";
begin
	tx_available <= tx_available_r;
    process(bclk_in)
    begin
        if bclk_in'event and bclk_in='1' then
			if state = t_none then 
				tx_available_r <= '1'; 
			else 
				tx_available_r <= '0';
			end if;
		end if;
	end process;
	
    process(bclk_in,tx_cmd,tx_buffer)
    variable count:std_logic_vector(4 downto 0):="00000";
    variable t_bitcnt:integer:=0;
    variable txds:std_logic;
    begin
        if bclk_in'event and bclk_in='1' then
            case state is
                when t_none=>
					txd_done<='0';
                    if tx_cmd='1' then
                        state<=t_start;
                        
                    else
                        state<=t_none;
                    end if;
                when t_start=>
                    if count="01111" then 
                        state<=t_shift;
                        count:="00000";
                    else
                        count:=count+'1';
                        txds:='0';
                        state<=t_start;
                    end if;
                when t_wait=>
                    if count="01110" then
                        if t_bitcnt=data_bits then
                            state<=t_stop;
                            t_bitcnt:=0;
                            count:="00000";
                        else
                            state<=t_shift;
                        end if;
                        count:="00000";
                    else
                        count:=count+'1';
                        state<=t_wait;
                    end if;
                when t_shift=>
                    txds:=tx_buffer(t_bitcnt);
                    t_bitcnt:=t_bitcnt+1;
                    state<=t_wait;
                when t_stop=>
                    if count="01111" then
                        if tx_cmd='0' then
                            state<=t_none;
                            count:="00000";
                        else
                            count:=count;
                            state<=t_stop;
                        end if;
                        txd_done<='1';
                    else
                        count:=count+'1';
                        txds:='1';
                        state<=t_stop;
                    end if;
                when others=>state<=t_none;
            end case;
        end if;
        txd_out<=txds;
    end process;
end beheavior;
