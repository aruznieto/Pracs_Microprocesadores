----------------------------------------------------------------------------------
-- Company: 	UPCT - SDBM
-- Engineer:	Andrés Ruz Nieto y Diego Ismael Antolinos García
-- 
-- Create Date:    18:30:11 05/12/2019 
-- Design Name: 	 
-- Module Name:    ALU - Behavioral 
-- Project Name:   Diseño de una ALU
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           A_in : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           A_out : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           OP_in : in  STD_LOGIC_VECTOR (4 DOWNTO 0);
           A_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           B_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           TipoOP_out : out  STD_LOGIC_VECTOR (1 DOWNTO 0);
           SALIDA_ALU : out  STD_LOGIC_VECTOR (7 DOWNTO 0));
end ALU;

architecture Behavioral of ALU is

begin
-- REGISTRO OP_IN
	PROCESS(clk)
		BEGIN
			IF(clk´EVENT AND clk='1') THEN 
				OP_in <= OP;
			END IF
	END PROCESS

end Behavioral;

