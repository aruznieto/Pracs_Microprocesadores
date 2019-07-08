----------------------------------------------------------------------------------
-- Company: 	UPCT - SDBM
-- Engineer:	Andres Ruz Nieto y Diego Ismael Antolinos Garcia
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
           BTN_IN : in  STD_LOGIC;
           TX_READY : out  STD_LOGIC;
			  TSR : out STD_LOGIC_VECTOR(9 downto 0);
           TX_OUT : out  STD_LOGIC;
			  RX_IN : in  STD_LOGIC;
           RX_DATA : out  STD_LOGIC_VECTOR(7 downto 0);
           RX_NEWDATA : out  STD_LOGIC
			  );
end UART;

architecture Behavioral of UART is
	signal BTN : STD_LOGIC;
	signal TX_START : STD_LOGIC;
	signal ACTUALIZACION_TX : STD_LOGIC;
	signal TX_NBIT : unsigned(3 downto 0);
	signal registro : STD_LOGIC_VECTOR(9 downto 0);
	signal reinicia : STD_LOGIC;
	signal disable_TX : STD_LOGIC;
	signal enable_load : STD_LOGIC;
	signal enable_TX_Ready : STD_LOGIC;
	signal contador_baudios : unsigned(15 downto 0);
	signal registrorx : STD_LOGIC_VECTOR(8 downto 0);
	signal ACTUALIZACION_RX : STD_LOGIC;
	signal RX_NBIT : unsigned(3 downto 0);
	signal reiniciarx : STD_LOGIC;
	signal enable_RX : STD_LOGIC;
	signal enable_rxnewdata : STD_LOGIC;
	signal RSR : STD_LOGIC_VECTOR(7 downto 0);
	signal contador_baudiosrx : unsigned(15 downto 0);
	
	-- ESTADOS DE LAS FMS
-- ############################################
	type estados_btn is (cero,flanco,uno);
	signal actual_btn, siguiente_btn : estados_btn;
	
	type estados_tx is (idle, TX_inicio, TX_datos);
	signal actual_tx, siguiente_tx :estados_tx;
	
	type estados_rx is (idle,RX_inicio,RX_datos,RX_fin);
	signal actual_rx, siguiente_rx : estados_rx;
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
			CASE actual_tx is
				WHEN idle => 
					reinicia <= '1';
					disable_TX <= '0';
					enable_load <= '0';
					enable_TX_Ready <= '1';
				WHEN TX_inicio => 
					reinicia <= '0';
					disable_TX <= '1';
					enable_load <= '1';
					enable_TX_Ready <= '0';
				WHEN TX_datos => 
					reinicia <= '0';
					disable_TX <= '1';
					enable_load <= '0';
					enable_TX_Ready <= '0';
			END CASE;
	END PROCESS;
	
	proceso_siguiente_estado_tx:PROCESS(actual_tx,TX_START,TX_NBIT)
		BEGIN
			CASE actual_tx is
				WHEN idle => 
					IF(TX_START = '1') THEN
						siguiente_tx <= TX_inicio;
					ELSE
						siguiente_tx <= idle;
					END IF;
					
				WHEN TX_inicio =>
						siguiente_tx <= TX_datos;
					
				WHEN TX_datos =>
					IF(TX_NBIT = 10) THEN
						siguiente_tx <= idle;
					ELSE
						siguiente_tx <= TX_datos;
					END IF;
					
			END CASE;
	END PROCESS;
-- ############################################

	-- FMS RX
-- ############################################
	PROCESS(reset,clk)
		BEGIN
			IF(reset='1') THEN
				actual_rx <= idle;
			ELSIF(clk'event and clk='1') THEN
				actual_rx <= siguiente_rx;
			END IF;
	END PROCESS;
		
	proceso_salida_rx:PROCESS(actual_rx)
		BEGIN
			CASE actual_rx is
				WHEN idle => 
					reiniciarx <= '1';
					enable_RX <= '0';
					enable_rxnewdata <= '0';
				WHEN RX_inicio => 
					reiniciarx <= '0';
					enable_RX <= '1';
					enable_rxnewdata <= '0';
				WHEN RX_datos =>
					reiniciarx <= '0';
					enable_RX <= '1';
					enable_rxnewdata <= '0';
				WHEN RX_fin => 
					reiniciarx <= '0';
					enable_RX <= '0';
					enable_rxnewdata <= '1';
			END CASE;
	END PROCESS;
	
	proceso_siguiente_estado_rx:PROCESS(actual_rx,RX_IN,RX_NBIT)
		BEGIN
			CASE actual_rx is
				WHEN idle => 
					IF(RX_IN = '0') THEN
						siguiente_rx <= RX_inicio;
					ELSE
						siguiente_rx <= idle;
					END IF;
					
				WHEN RX_inicio =>
						siguiente_rx <= RX_datos;
					
				WHEN RX_datos =>
					IF(RX_NBIT = 10) THEN
						siguiente_rx <= RX_fin;
					ELSE
						siguiente_rx <= RX_datos;
					END IF;
					
				WHEN RX_fin =>
					siguiente_rx <= idle;
					
			END CASE;
	END PROCESS;
-- ############################################

	-- BTN
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF(RESET = '1') THEN
				BTN <= '0';
			ELSIF(clk'event and clk = '1') THEN
				BTN <= BTN_IN;
			END IF;
	END PROCESS;

	-- regTX_Ready
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF(RESET = '1') THEN
				TX_READY <= '1';
			ELSIF(clk'event and clk = '1') THEN
				IF(enable_TX_Ready = '1') THEN
					TX_READY <= '1';
				ELSE 
					TX_READY <= '0';
				END IF;
			END IF;
	END PROCESS;
-- ############################################

	-- Contador de transmisión
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF(RESET = '1') THEN
				TX_NBIT <= (OTHERS => '0');
			ELSIF(clk'event and clk = '1') THEN
				IF (reinicia = '1') THEN
				TX_NBIT <= (OTHERS => '0');
				ELSIF (disable_TX = '1') THEN
					IF (TX_NBIT = 10) THEN
						TX_NBIT <= (OTHERS => '0');
					ELSIF(ACTUALIZACION_TX = '1') THEN
						TX_NBIT <= TX_NBIT + 1;
					END IF;
				END IF;
			END IF;
	END PROCESS;
-- ############################################

	-- Desplazamiento
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF (RESET = '1') THEN
				registro <= (OTHERS => '1');
			ELSIF (clk'event and clk = '1') THEN
				IF (reinicia = '1') THEN
					registro <= (OTHERS => '1');
				ELSIF (disable_TX = '1') THEN
					IF(enable_load = '1') THEN
						registro <= '1' & TX_DATA & '0';
					ELSIF (ACTUALIZACION_TX = '1') THEN
						registro <= '1' & registro(9 downto 1);
					END IF;
				END IF;
			END IF;
	END PROCESS;
	
	TSR <= registro;
	TX_OUT <= registro(0);
-- ############################################

	-- Baud rate generator
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF (RESET = '1') THEN
				contador_baudios <= (OTHERS => '0'); -- 1/BAUDIOS y RESULTADO ENTRE 20ns (50MHz)
			ELSIF (clk'event and clk = '1') THEN
				IF (reinicia = '1') THEN
					contador_baudios <= (OTHERS => '0');
				ELSIF (disable_TX = '1') THEN
					IF (contador_baudios = 5208) THEN
						contador_baudios <= (OTHERS => '0');
					ELSE
						contador_baudios <= contador_baudios + 1;
					END IF;
				END IF;
			END IF;	
	END PROCESS;
-- ############################################

	-- ACTUALIZACION_TX
-- ############################################
	PROCESS(contador_baudios)
		BEGIN
			IF (contador_baudios = 5208) THEN
				ACTUALIZACION_TX <= '1';
			ELSE
				ACTUALIZACION_TX <= '0';
			END IF;
	END PROCESS;
-- ############################################

-- ============================================
-- RX
-- ============================================

	-- Contador de recepción
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF(RESET = '1') THEN
				RX_NBIT <= (OTHERS => '0');
			ELSIF(clk'event and clk = '1') THEN
				IF (reiniciarx = '1') THEN
				RX_NBIT <= (OTHERS => '0');
				ELSIF (enable_RX = '1') THEN
					IF (RX_NBIT = 10) THEN
						RX_NBIT <= (OTHERS => '0');
					ELSIF(ACTUALIZACION_RX = '1') THEN
						RX_NBIT <= RX_NBIT + 1;
					END IF;
				END IF;
			END IF;
	END PROCESS;
-- ############################################

	-- Desplazamiento
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF (RESET = '1') THEN
				registrorx <= (OTHERS => '1');
			ELSIF (clk'event and clk = '1') THEN
				IF (reiniciarx = '1') THEN
					registrorx <= (OTHERS => '1');
				ELSIF (enable_RX = '1') THEN
					IF (ACTUALIZACION_RX = '1') THEN
						registrorx <= RX_IN & registrorx(8 downto 1);
					END IF;
				END IF;
			END IF;
	END PROCESS;
	
	RSR <= registrorx(8 downto 1);
-- ############################################

	-- regRX (RSR to RX_DATA)
-- ############################################
	PROCESS(clk)
		BEGIN
			IF(clk'event and clk = '1') THEN
				IF(enable_RX = '1') THEN
					RX_DATA <= RSR;
				END IF;
			END IF;
		END PROCESS;	
-- ############################################

	-- regRX_newdata
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF (RESET='1') THEN
				RX_NEWDATA <= '0';
			ELSIF(clk'event and clk = '1') THEN
				IF(enable_rxnewdata = '1') THEN
					RX_NEWDATA <= '1';
				ELSE 
					RX_NEWDATA <= '0';
				END IF;
			END IF;
	END PROCESS;
-- ############################################

	-- Baud rate generator
-- ############################################
	PROCESS(clk,RESET)
		BEGIN
			IF (RESET = '1') THEN
				contador_baudiosrx <= (OTHERS => '0'); -- 1/BAUDIOS y RESULTADO ENTRE 20ns (50MHz)
			ELSIF (clk'event and clk = '1') THEN
				IF (reiniciarx = '1') THEN
					contador_baudiosrx <= (OTHERS => '0');
				ELSIF (enable_RX = '1') THEN
					IF (contador_baudiosrx = 5208) THEN
						contador_baudiosrx <= (OTHERS => '0');
					ELSE
						contador_baudiosrx <= contador_baudiosrx + 1;
					END IF;
				END IF;
			END IF;	
	END PROCESS;
-- ############################################

	-- ACTUALIZACION_RX
-- ############################################
	PROCESS(contador_baudiosrx)
		BEGIN
			IF (contador_baudiosrx = 5208) THEN
				ACTUALIZACION_RX <= '1';
			ELSE
				ACTUALIZACION_RX <= '0';
			END IF;
	END PROCESS;
-- ############################################
end Behavioral;

