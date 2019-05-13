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
           DatoA : inout  STD_LOGIC_VECTOR (7 DOWNTO 0);
           B_in : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           DatoB : inout  STD_LOGIC_VECTOR (7 DOWNTO 0);
           OP_in : in  STD_LOGIC_VECTOR (4 DOWNTO 0);
           OP : inout  STD_LOGIC_VECTOR (4 DOWNTO 0);
           A_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           B_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           LEDs : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           TipoOP_out : inout  STD_LOGIC_VECTOR (1 DOWNTO 0);
           TipoOP : in  STD_LOGIC_VECTOR (1 DOWNTO 0);
           SALIDA_ALU : inout  STD_LOGIC_VECTOR (7 DOWNTO 0));
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
	
-- REGISTRO LEDS
	PROCESS(clk)
		BEGIN
			IF(clk'EVENT AND clk='1') THEN 
				IF(TipoOP="10") THEN
					LEDs <= SALIDA_ALU;
				END IF;
			END IF;
	END PROCESS;

-- ALU (MULTIPLEXOR)
	PROCESS(OP,DatoA,DatoB)
		BEGIN
			IF(OP="00001") THEN
				SALIDA_ALU <= DatoA OR DatoB;
			ELSIF(OP="00010") THEN
				SALIDA_ALU <= DatoA AND DatoB;
			ELSIF(OP="00011") THEN
				SALIDA_ALU <= DatoA XOR DatoB;
			ELSIF(OP="00100") THEN
				SALIDA_ALU <= DatoA NAND DatoB;
			ELSIF(OP="00101") THEN
				SALIDA_ALU <= NOT DatoA;
			ELSIF(OP="00110") THEN
				SALIDA_ALU <= DatoA ROR 1;
			ELSIF(OP="00111") THEN
				SALIDA_ALU <= DatoA ROL 1;
			END IF;
	END PROCESS;

-- TipoOP
	PROCESS(OP)
		BEGIN
			IF(OP="00001" or OP="00010" or OP="00011" or OP="00100" or OP="00101" or OP="00110" or OP="00111") THEN
				TipoOP <= "10";
			ELSE
				TipoOP <= "00";
			END IF;
	END PROCESS;
		
end Behavioral;

-- Codigos de operaciones l�gicas que puede realizar la ALU

-- OR = 00001
-- AND = 00010
-- XOR = 00011
-- NAND = 00100
-- NOT A = 00101
-- RR A = 00110
-- RL A = 00111
