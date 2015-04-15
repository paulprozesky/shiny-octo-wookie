library IEEE;
use IEEE.std_logic_1164.all;

entity pfb_core_snbxfft32 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    en_in: in std_logic; 
    pol0_in: in std_logic_vector(35 downto 0); 
    pol1_in: in std_logic_vector(35 downto 0); 
    sync_in: in std_logic; 
    en_out: out std_logic; 
    pol0_out: out std_logic_vector(35 downto 0); 
    pol1_out: out std_logic_vector(35 downto 0); 
    specsync_out: out std_logic; 
    sync_out: out std_logic
  );
end pfb_core_snbxfft32;

architecture structural of pfb_core_snbxfft32 is
begin
end structural;

