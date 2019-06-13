----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:12:34 06/13/2019 
-- Design Name: 
-- Module Name:    UART - Behavioral 
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

entity UART is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           TX_DATA : in  STD_LOGIC_VECTOR(7 downto 0);
			  RX_DATA : out  STD_LOGIC_VECTOR(7 downto 0);
			  RX_NEWDATA : out  STD_LOGIC_VECTOR(7 downto 0);
           BTN_IN : in  STD_LOGIC;
			  RX_IN : in STD_LOGIC;
           TX_READY : out  STD_LOGIC;
           TX_OUT : out  STD_LOGIC);
end UART;

architecture Behavioral of UART is
	signal BTN : STD_LOGIC;
	signal TX_START : STD_LOGIC;
	signal ACTUALIZACION_TX : STD_LOGIC;
	signal ACTUALIZACION_RX : STD_LOGIC;
	signal TSR : STD_LOGIC;
	signal RSR : STD_LOGIC;
	signal TX_NBIT : STD_LOGIC;
	signal RX_NBIT : STD_LOGIC;
	
	-- ESTADOS DE LAS FMS
-- ############################################
	type estados_btn is (cero,flanco,uno);
	signal actual_btn, siguiente_btn : estados_btn;
	
	type estados_tx is (idle, TX_inicio, TX_datos);
	signal actual_tx, siguiente_tx :estados_tx;
	
	type estados_rx is (idle, RX_inicio, RX_datos, RX_fin);
	signal actual_rx, siguiente_rx :estados_rx;
-- ############################################

	BEGIN
	
	-- FMS BOTON
-- ############################################
	PROCESS(reset,clk)
		BEGIN
			IF(reset='1') THEN
				actual_btn <= cero;
			ELSIF(clk'event and clk='1') THEN
				actual_btn <= siguiente_btn;
			END IF;
	END PROCESS;
		
	proceso_salida_btn:PROCESS(actual_btn)
		BEGIN
			CASE actual_btn is
				WHEN cero => TX_START <= '0';
				WHEN flanco => TX_START <= '1';
				WHEN uno => TX_START <= '0';
			END CASE;
	END PROCESS;
	
	proceso_siguiente_estado_btn:PROCESS(actual_btn,BTN)
		BEGIN
			CASE actual_btn is
				WHEN cero => 
					IF(BTN = '1') THEN
						siguiente_btn <= flanco;
					ELSE
						siguiente_btn <= cero;
					END IF;
					
				WHEN flanco =>
					IF(BTN = '1') THEN
						siguiente_btn <= uno;
					ELSE
						siguiente_btn <= cero;
					END IF;
					
				WHEN uno =>
					IF(BTN = '1') THEN
						siguiente_btn <= uno;
					ELSE
						siguiente_btn <= cero;
					END IF;
					
			END CASE;
	END PROCESS;
-- ############################################

	-- FMS TX
-- ############################################
	PROCESS(reset,clk)
		BEGIN
			IF(reset='1') THEN
				actual_tx <= idle;
			ELSIF(clk'event and clk='1') THEN
				actual_tx <= siguiente_tx;
			END IF;
	END PROCESS;
		
	proceso_salida_tx:PROCESS(actual_tx)
		BEGIN
			CASE actual_btn is
				WHEN idle => TX_START <= '0';
				WHEN TX_inicio => TX_START <= '1';
				WHEN TX_fin => TX_START <= '0';
			END CASE;
	END PROCESS;
	
	proceso_siguiente_estado_tx:PROCESS(actual_tx,BTN)
		BEGIN
			CASE actual_tx is
				WHEN idle => 
					IF(TX_START = '1') THEN
						siguiente_tx <= TX_inicio;
					ELSE
						siguiente_tx <= idle;
					END IF;
					
				WHEN TX_inicio =>
					IF(BTN = '1') THEN
						siguiente_tx <= uno;
					ELSE
						siguiente_tx <= cero;
					END IF;
					
				WHEN TX_datos =>
					IF(BTN = '1') THEN
						siguiente_tx <= uno;
					ELSE
						siguiente_tx <= cero;
					END IF;
					
			END CASE;
	END PROCESS;
-- ############################################

	-- FMS RX
-- ############################################
-- ############################################
end Behavioral;

