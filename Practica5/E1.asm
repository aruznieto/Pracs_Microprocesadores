;-------------------------------------------------------
		LIST p=16F876A
		INCLUDE "p16f876a.inc"
		__CONFIG _XT_OSC & _WDT_OFF & _LVP_OFF
;-------------------------------------------------------
		ORG 0
		goto inicio

		ORG 4
		goto ISR
		ORG 5
;-------------------------------------------------------

inicio

		BSF 	STATUS,RP0 ; Cambiamos al banco 1

		MOVLW 	b'11111111'
		MOVWF 	TRISC ; Ponemos todo PORTC como entrada

		CLRF 	TRISB ; Ponemos todo PORTB como salida

		MOVLW 	.12
		MOVWF 	SPBRG ; Asignamos el ratio de baudios para el modo asincrono (VER EN LA TABLA DEL MANUAL REDUCIDO QUE SE PUDE ENCONTRAR EN LA PAGINA 98)

		BSF 	TXSTA, BRGH ; Activamos el BIT para que el modo asincrono sea a baja velocidad (tambi�n se ve en la tabla)
		BSF		TXSTA, TXEN ; Activamos el BIT que habilita la transmisi�n
		BSF		PIE1, RCIE ; Activamos interrupcion de recepci�n

		BCF 	STATUS,RP0 ; Cambiamos al banco 0

		BSF		RCSTA, SPEN ; Activamos el BIT para habilitar el puerto serie
		BSF		RCSTA, CREN ; Activamos el BIT para que est� recibiendo continuamente

		BSF 	INTCON, GIE ; Habilitamos el BIT de interrupciones - PAGINA 20 del manual resumido
		BSF		INTCON, PEIE ; Habilitamos el BIT de interrupciones de perifericos - PAGINA 20 del manual resumido


main
		goto main
;-------------------------------------------------------

ISR
		BTFSS 	PIR1,RCIF ; Si RCIF est� activo saltaremos RETFIE 
RETFIE

		MOVF 	RCREG,0
		MOVWF 	PORTB ; Movemos el dato recibido a PORTB
		MOVWF 	TXREG ; Hacemos un "echo" al PC
RETFIE
;-------------------------------------------------------

END

; Hecho por Los Telematicos