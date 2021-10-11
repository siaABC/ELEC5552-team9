library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity rxd is
    generic(data_bits:integer:=8);
    port(bclk_in,rxd_in:in std_logic;
          rx_ready:out std_logic;
          rx_buffer:out std_logic_vector(7 downto 0));
end rxd;
architecture beheavior of rxd is
type states is(r_start,r_center,r_wait,r_sample,r_stop);
signal state:states:=r_start;
signal rxd_sync:std_logic;
begin
    process(rxd_in)
    begin
        if rxd_in='0' then rxd_sync<='0';
        else rxd_sync<='1';
        end if;
    end process;

    process(bclk_in,rxd_sync)
    variable count:std_logic_vector(3 downto 0);
    variable r_cnt:integer:=0;
    variable buf:std_logic_vector(7 downto 0);
    begin
        if bclk_in'event and bclk_in='1' then
            case state is
                when r_start=>
                    if rxd_sync='0' then 
                        state<=r_center;
                        rx_ready<='0';
                        r_cnt:=0;
                    else state<=r_start;rx_ready<='0';
                    end if;
                when r_center=>
                    if rxd_sync='0' then
                        if count="0100"then 
                            state<=r_wait;
                            count:="0000";
                        else
                            count:=count+'1';
                            state<=r_center;
                        end if;
                    else
                        state<=r_start;
                    end if;
                when r_wait=>
                    if count="1110" then
                        if r_cnt=data_bits then
                            state<=r_stop;
                        else
                           state<=r_sample;
                        end if;
                        count:="0000";
                    else
                        count:=count+'1';
                        state<=r_wait;
                    end if;
                when r_sample=>
                    buf(r_cnt):=rxd_sync;
                    r_cnt:=r_cnt+1;
                    state<=r_wait;
                when r_stop=>
                    rx_ready<='1';
                    rx_buffer<=buf;
                    state<=r_start;
                when others=>
                    state<=r_start;
            end case;               
        end if;
    end process;
end beheavior;