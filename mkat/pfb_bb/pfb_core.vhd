library IEEE;
use IEEE.std_logic_1164.all;

entity pfb_core is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    en_in: in std_logic; 
    pol0_in: in std_logic_vector(79 downto 0); 
    pol1_in: in std_logic_vector(79 downto 0); 
    shift_in: in std_logic_vector(31 downto 0); 
    sync_in: in std_logic; 
    en_out: out std_logic; 
    of_out: out std_logic_vector(1 downto 0); 
    pol0_out: out std_logic_vector(143 downto 0); 
    pol1_out: out std_logic_vector(143 downto 0); 
    sync_out: out std_logic
  );
end pfb_core;

architecture structural of pfb_core is
begin
end structural;

