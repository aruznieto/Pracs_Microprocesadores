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
	signal enable_carga_paso1: STD_LOGIC;
	signal enable_desplaza_paso2: STD_LOGIC;
	signal enable_actualiza_salida: STD_LOGIC;
	signal enable_contador_iteraciones: STD_LOGIC;
	signal BINARIO: STD_LOGIC_VECTOR(3 downto 0);
	signal DIGITO1: STD_LOGIC_VECTOR(3 downto 0);
	signal DIGITO2: STD_LOGIC_VECTOR(3 downto 0);
	signal DIGITO3: STD_LOGIC_VECTOR(3 downto 0);
	signal actualiza_display: STD_LOGIC_VECTOR(3 downto 0);
	signal contador_400us: unsigned(15 downto 0);
	type state_type is (START,PASO1,PASO2,FIN);
	signal estado_actual, siguiente_estado : state_type;
	signal outputi : STD_LOGIC;
	signal contador_iteraciones : unsigned(3 downto 0);
	
begin

-- FMS

STATE_PROC:process(clk)
	BEGIN
		IF(clk'event and clk='1') THEN
			IF(reset='1') THEN
				estado_actual <= START;
			ELSE
				estado_actual <= siguiente_estado;
			END IF;
		END IF;
	END PROCESS;

OUTPUT_PROC:process(estado_actual)
	BEGIN
		IF(estado_actual = START) THEN
			reinicia <= '1';
			enable_carga_paso1 <= '0';
			enable_desplaza_paso2 <= '0';
			enable_actualiza_salida <= '0';
			enable_contador_iteraciones <= '1';
		ELSIF(estado_actual = PASO1) THEN
			reinicia <= '0';
			enable_carga_paso1 <= '1';
			enable_desplaza_paso2 <= '0';
			enable_actualiza_salida <= '0';
			enable_contador_iteraciones <= '1';
		ELSIF(estado_actual = PASO2) THEN
			reinicia <= '0';
			enable_carga_paso1 <= '0';
			enable_desplaza_paso2 <= '1';
			enable_actualiza_salida <= '0';
			enable_contador_iteraciones <= '0';
		ELSE
			reinicia <= '0';
			enable_carga_paso1 <= '0';
			enable_desplaza_paso2 <= '0';
			enable_actualiza_salida <= '1';
			enable_contador_iteraciones <= '0';
		END IF;
	END PROCESS;

NEXT_STATE_PROC:process(estado_actual,iteracion)
		BEGIN
			CASE(estado_actual) is
				WHEN START =>
					siguiente_estado <= PASO1;
				WHEN PASO1 =>
					IF (iteracion <= 15) THEN
						siguiente_estado <= PASO1;
					ELSE
						siguiente_estado <= PASO2;
					END IF;
				WHEN PASO2 => 
					siguiente_estado <= FIN;
				WHEN FIN =>
					siguiente_estado <= START;
				WHEN others =>
					siguiente_estado <= START;
			END CASE;
		END PROCESS;

PROCESS(clk,reinicia,enable_contador_iteraciones)
	BEGIN
		IF (enable_contador_iteraciones = '0') THEN
			contador_iteraciones <= (OTHERS => '0');
		ELSE
			IF(reinicia='1') THEN
				contador_iteraciones <= (OTHERS => '0');
			ELSIF(clk'EVENT AND clk='1') THEN
				IF(contador_iteraciones = 14) THEN
					contador_iteraciones <= (OTHERS => '0');
				ELSE
					contador_iteraciones <= contador_iteraciones + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
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

