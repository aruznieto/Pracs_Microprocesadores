----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:33:42 05/31/2019 
-- Design Name: 
-- Module Name:    Display7Seg - Behavioral 
-- Project Name: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display7Seg is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           dato : in  STD_LOGIC;
			  AN_display7seg: out STD_LOGIC_VECTOR(3 downto 0);
           display7seg : out  STD_LOGIC_VECTOR(7 downto 0));
end Display7Seg;

architecture Behavioral of Display7Seg is
	signal UNIDADES: STD_LOGIC_VECTOR(3 downto 0);
	signal DECENAS: STD_LOGIC_VECTOR(3 downto 0);
	signal CENTENAS: STD_LOGIC_VECTOR(3 downto 0);
	signal datoBCD: STD_LOGIC_VECTOR(3 downto 0);
	signal iteracion: STD_LOGIC_VECTOR(3 downto 0);
	signal reinicia: STD_LOGIC_VECTOR(3 downto 0);
	signal enable_carga_paso1: STD_LOGIC_VECTOR(3 downto 0);
	signal enable_desplaza_paso2: STD_LOGIC_VECTOR(3 downto 0);
	signal enable_actualiza_salida: STD_LOGIC_VECTOR(3 downto 0);
	signal enable_contador_iteraciones: STD_LOGIC_VECTOR(3 downto 0);
	signal BINARIO: STD_LOGIC_VECTOR(3 downto 0);
	signal DIGITO1: STD_LOGIC_VECTOR(3 downto 0);
	signal DIGITO2: STD_LOGIC_VECTOR(3 downto 0);
	signal DIGITO3: STD_LOGIC_VECTOR(3 downto 0);
	signal actualiza_display: STD_LOGIC_VECTOR(3 downto 0);
	signal contador_400us: unsigned(15 downto 0);
begin
-- Contador 400us (contar hasta 20000)
PROCESS(clk,reset)
	BEGIN
		IF(reset='1') THEN
			contador_400us <= (OTHERS => '0');
		ELSIF(clk='1' AND clk'EVENT) THEN
				IF(contador_400us = 19999) THEN
					contador_400us <= (OTHERS => '0');
				ELSE
					contador_400us <= contador_400us + 1;
				END IF;
		END IF;
	END PROCESS;
	
-- Selector Display
PROCESS(reset,clk)
	BEGIN
		IF(reset='1') THEN
			 actualiza_display <= "1110";
		ELSIF(clk'EVENT AND clk='1') THEN
			IF(contador_400us=19999) THEN
			actualiza_display <= actualiza_display(2 downto 0) & actualiza_display(3);
			END IF;
		END IF;
END PROCESS;

AN_display7seg <= actualiza_display;

end Behavioral;

