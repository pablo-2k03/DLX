	.data
PrintFormat:	.asciiz	"%d\n"
				.align	2
PrintPar:		.word	PrintFormat
PrintValue:		.space	4
;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN 
valor_inicial:	.word	10

;; VARIABLES DE SALIDA
secuencia:		.space	120*4
secuencia_tamanho:	.word	0
secuencia_maximo:	.word	0
secuencia_valor_medio:	.float	0
lista:			.space	9*4
lista_valor_medio:	.float	0

;; Otras variables
contador:		.word	0
lista_tamanho:	.word	0

.text
.global main

main:

    lw		r1, valor_inicial ;; Cargar valor inicial en r1

    sw      secuencia_maximo,r0
    sw      contador,r0

    add		r2,r0,r1  ; r2 = N
	add		r3,r0,r2 ; r3 = A[N-1]
	add		r4,r0,r2 ; r4 = A[N]
	add 	r5,r0,3

loop:

    lw		r6, secuencia_maximo ;; Cargar máximo de la secuencia en r22
	lw		r7, secuencia_tamanho ;; Cargar tamaño de la secuencia en r23
    lw		r8, contador ;; Cargar contador en r21

	addi 	r24,r0,#4 ;; Cargar en r24 el valor inmediato 4
	mult	r25,r7,r24 ;; Multiplicar el tamaño de la secuencia por 4

	addi	r20, r7, 1 ;; Incrementar tamaño de la secuencia
    add		r8, r8, r3 ;; Sumar al contador el valor actual de la secuencia

    sw		secuencia_tamanho, r20 
    sw 		secuencia(r25), r3 
    sw		contador, r8 ;; Guardar contador en r21
    ;;Verificar si el valor actual es mayor al máximo
    slt r26, r3, r6 ;; Comprobar si r3 < r21, en caso afirmativo, r22 = 1


    beqz r26, maximo ;; Si r22 = 0, saltar a maximo

continua:
    subi    r6,r3,1
    jal print
    beqz r6, finish
    andi r27,r3,1
    beqz r27, par
    mult r4,r3,r5
    addi r4,r4,1
    add r3,r4,r0
    j loop
par:
    srli r4,r3,1
    add r3,r4,r0
    j loop
maximo:
	sw		secuencia_maximo, r3 ;; Guardar valor actual como máximo
    j continua
print:
    sw PrintValue, r4
    addi r14, r0, PrintPar
    trap 5
    jr r31

finish:
    ;; Calculamos el valor medio de la secuencia
    lw 		r9, lista_tamanho ;; Cargar tamaño de la lista en r24
    
    div		r10, r8, r7 ;; Dividir el contador por el tamaño de la secuencia
    
    subi    r10,r10,1 ;; Restar 1 al valor medio (REPRESENTACION)

    ;; Las 3 int sig son del Indice 0
    lw		r1, valor_inicial ;; Cargar valor inicial en r1
    lw      r7, secuencia_tamanho ;; Cargar tamaño de la secuencia en r23
    mult  r24, r1, r7 ;; Indice 0

    sw		secuencia_valor_medio, r10 ;; Guardar el valor medio de la secuencia
    sw 		lista_tamanho, r9 ;; Guardar tamaño de la lista

rellenar_lista:
    lw	r6, secuencia_maximo ;; Cargar máximo de la secuencia en r22 --> INDICE 1
    ;;Incrementamos el tamaño de la lista
    addi r9,r9,1

    mult r26,r6,r7 ;; INDICE 1

    ;; Guardamos el valor en la lista
    sw lista, r24


    sw lista_tamanho, r9


;;=============================== INDICE 1 =================================
    ;; Indice 1 vMax*vT

    ;; Cargamos en un registro el numero 4
    addi r21,r0,#4
    ;; Desplazamos
    mult r25,r9,r21

    ;;Incrementamos el tamaño de la lista
    addi r9,r9,1
    sw lista_tamanho, r9
    ;; Guardamos el valor en la lista
    sw lista(r25), r26

;;=============================== INDICE 2 =================================
    ;; Indice 2 vMed*vT
    lw  r10, secuencia_valor_medio

    addi r21,r0,#4     ;; Cargamos en un registro el numero 4

    mult r24,r10,r7


    ;; Desplazamos
    mult r25,r9,r21
    ;;Incrementamos el tamaño de la lista
    addi r9,r9,1
    ;; Guardamos el valor en la lista
    sw lista_tamanho, r9
    sw lista(r25), r24
;; =============================== INDICE 3 =================================
    ;; Indice 3 (vIni / vMax) * vT
    lw r1, valor_inicial ;; INDICE 3
    lw r9, lista_tamanho ;; INDICE 3
    lw r6, secuencia_maximo ;; INDICE 3
    lw r7, secuencia_tamanho ;; INDICE 3
    
    div r19,r1,r6 ;; INDICE 3

    mult r24,r19,r7
    ;; Desplazamos
    addi r21,r0,#4     ;; Cargamos en un registro el numero 4
    mult r25,r9,r21
    ;;Incrementamos el tamaño de la lista
    addi r9,r9,1
    ;; Guardamos el valor en la lista
    sw lista_tamanho, r9
    sw lista(r25), r24

    trap 0