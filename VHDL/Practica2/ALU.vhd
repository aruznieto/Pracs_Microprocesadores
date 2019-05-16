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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
-- Aquí se ponen solo las entradas y las salidas de la "caja"
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           A_in : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           B_in : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           OP_in : in  STD_LOGIC_VECTOR (4 DOWNTO 0);
           A_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           B_out : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           LEDs : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           RESULTADO : out  STD_LOGIC_VECTOR (7 DOWNTO 0);
           CERO : out  STD_LOGIC;
           SIGNO : out  STD_LOGIC;
           TipoOP_out : out  STD_LOGIC_VECTOR (1 DOWNTO 0));

end ALU;

architecture Behavioral of ALU is
-- Declaramos las señales internas
			signal OP : STD_LOGIC_VECTOR (4 DOWNTO 0);
			signal DatoA : STD_LOGIC_VECTOR (7 DOWNTO 0);
			signal DatoB : STD_LOGIC_VECTOR (7 DOWNTO 0);
			signal TipoOP : STD_LOGIC_VECTOR (1 DOWNTO 0);
			signal SALIDA_ALU : STD_LOGIC_VECTOR (7 DOWNTO 0);

begin
-- REGISTRO OP_IN, creamos el registro destinado a guardar OP_IN
	PROCESS(clk,reset)
		BEGIN
			IF (reset='1') THEN -- Si reset está activado pon OP a 0
				OP <= "00000";
			ELSIF(clk'EVENT AND clk='1') THEN -- Si llega un ciclo de reloj actualiza OP
				OP <= OP_in;
			END IF;
	END PROCESS;
	
-- REGISTRO A_IN, creamos el registro destinado a guardar A_IN
	PROCESS(clk,reset)
		BEGIN
			IF (reset='1') THEN -- Si reset esta activado pon DatoA a 0
				DatoA <= "00000000";
			ELSIF(clk'EVENT AND clk='1') THEN -- Si llega un ciclo de reloj actualiza DatoA
				DatoA <= A_in;
			END IF;
	END PROCESS;
	
-- REGISTRO B_IN, creamos el registro destinado a guardar B_IN
	PROCESS(clk,reset)
		BEGIN
			IF (reset='1') THEN -- Si reset esta activado pon DatoB a 0
				DatoB <= "00000000";
			ELSIF(clk'EVENT AND clk='1') THEN -- Si llega un ciclo de reloj actualiza DatoB
				DatoB <= B_in;
			END IF;
	END PROCESS;
	
-- REGISTRO TIPO OP, creamos el registro destinado a guardar TIPO OP
	PROCESS(clk,reset)
		BEGIN
			IF(clk'EVENT AND clk='1') THEN -- Si llega un ciclo de reloj actualiza TipoOP_out
				TipoOP_out <= TipoOP;
			END IF;
	END PROCESS;
	
-- REGISTRO LEDS
	PROCESS(clk,reset)
		BEGIN
			IF(clk'EVENT AND clk='1') THEN -- Si llega un ciclo de reloj actualiza LEDS
				IF(TipoOP="10") THEN
					LEDs <= SALIDA_ALU;
				END IF;
			END IF;
	END PROCESS;

			A_out <= DatoA; -- Damos valor a A_out
			B_out <= DatoB; -- Damos valor a B_out

-- ALU (MULTIPLEXOR)
	PROCESS(OP,DatoA,DatoB)
		BEGIN
			CASE OP IS -- Creamos un SWITCH de Java, para cada caso de OP, los codigos de 
						  -- las distintas operaciones se pueden ver a continuacion
						  
				-- ###### LOGICAS
					-- OR = 00001
					-- AND = 00010
					-- XOR = 00011
					-- NAND = 00100
					-- NOT A = 00101
					-- RR A = 00110
					-- RL A = 00111	
				WHEN "00001" => SALIDA_ALU <= DatoA OR DatoB;
				WHEN "00010" => SALIDA_ALU <= DatoA AND DatoB;
				WHEN "00011" => SALIDA_ALU <= DatoA XOR DatoB;
				WHEN "00100" => SALIDA_ALU <= DatoA NAND DatoB;
				WHEN "00101" => SALIDA_ALU <= NOT DatoA;
				WHEN "00110" =>
					SALIDA_ALU(6)  <= DatoA(7);
					SALIDA_ALU(5)  <= DatoA(6);
					SALIDA_ALU(4)  <= DatoA(5);
					SALIDA_ALU(3)  <= DatoA(4);
					SALIDA_ALU(2)  <= DatoA(3);
					SALIDA_ALU(1)  <= DatoA(2);
					SALIDA_ALU(0)  <= DatoA(1);
					SALIDA_ALU(7)  <= DatoA(0);
				WHEN "00111" =>
					SALIDA_ALU(7)  <= DatoA(6);
					SALIDA_ALU(6)  <= DatoA(5);
					SALIDA_ALU(5)  <= DatoA(4);
					SALIDA_ALU(4)  <= DatoA(3);
					SALIDA_ALU(3)  <= DatoA(2);
					SALIDA_ALU(2)  <= DatoA(1);
					SALIDA_ALU(1)  <= DatoA(0);
					SALIDA_ALU(0)  <= DatoA(7);
					
				-- ###### ARITMETICAS
					-- A+0 = 01000
					-- B+0 = 01001
					-- A+B = 01010
					-- A-B = 01101
					-- A+1 = 01100
					-- A-1 = 01101
					-- 2*A = 01110
					-- A/2 = 01111
					-- |A| = 10000
					-- MAX(A,B) = 10001
					-- MIN(A,B) = 10010
				WHEN "01000" => SALIDA_ALU <= DatoA;
				WHEN "01001" => SALIDA_ALU <= DatoB;
				WHEN "01010" => SALIDA_ALU <= A+B;
				WHEN "01101" => SALIDA_ALU <= A+B;
				WHEN "01100" => SALIDA_ALU <= A+B;
				WHEN "01101" => SALIDA_ALU <= A+B;
				WHEN "01110" => SALIDA_ALU <= A+B;
				WHEN "01111" => SALIDA_ALU <= A+B;
				WHEN "10000" => SALIDA_ALU <= A+B;
				WHEN "10001" => SALIDA_ALU <= A+B;
				WHEN "10010" => SALIDA_ALU <= A+B;
				
				-- ###### COMPARACION
					-- A<B = 10011
					-- A>B = 10100
					-- A=B = 10101
				WHEN "10011" => SALIDA_ALU <= A+B;
				WHEN "10100" => SALIDA_ALU <= A+B;
				WHEN "10101" => SALIDA_ALU <= A+B;
				WHEN others => SALIDA_ALU <= "00000000";
			END CASE;
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