----------------------------------------------------------------------------------
-- Company: 	UPCT - SDBM
-- Engineer:	Andres Ruz Nieto y Diego Ismael Antolinos Garcia
-- 
-- Create Date:    18:30:11 05/12/2019 
-- Design Name: 	 
-- Module Name:    ALU - Behavioral 
-- Project Name:   ALU Design
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
           DatoA : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           B_in : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           DatoB : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           OP_in : in  STD_LOGIC_VECTOR (4 DOWNTO 0);
           OP : out  STD_LOGIC_VECTOR (4 DOWNTO 0);
           A_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           B_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           TipoOP_out : out  STD_LOGIC_VECTOR (1 DOWNTO 0);
           TipoOP : in  STD_LOGIC_VECTOR (1 DOWNTO 0);
           SALIDA_ALU : out  STD_LOGIC_VECTOR (7 DOWNTO 0));
end ALU;

architecture Behavioral of ALU is

begin
-- REGISTRO OP_IN
	PROCESS(clk)
		BEGIN
			IF(clk'EVENT AND clk='1') THEN 
				OP <= OP_in;
			END IF;
	END PROCESS;
	
-- REGISTRO A_IN
	PROCESS(clk)
		BEGIN
			IF(clk'EVENT AND clk='1') THEN 
				DatoA <= A_in;
			END IF;
	END PROCESS;
	
-- REGISTRO B_IN
	PROCESS(clk)
		BEGIN
			IF(clk'EVENT AND clk='1') THEN 
				DatoB <= B_in;
			END IF;
	END PROCESS;
	
-- REGISTRO TIPO OP
	PROCESS(clk)
		BEGIN
			IF(clk'EVENT AND clk='1') THEN 
				TipoOP_out <= TipoOP;
			END IF;
	END PROCESS;
	

end Behavioral;

