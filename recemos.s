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
    lw      r7, secuencia_tamanho ;; Cargar tamaño de la secuencia en r23
    lw      r6, secuencia_maximo ;; Cargar máximo de la secuencia en r22
    lw      r1, valor_inicial ;; Cargar valor inicial en r1

    div		r10, r8, r7 ;; Dividir el contador por el tamaño de la secuencia

rellenar_lista:
    addi   r11, r0, 1 ;; Posterior division 
    mult r12,r1,r7 ;; vIni * vT

    movi2fp f1, r12 ;; INDICE 0
    addi r9,r9,1 ;; INDICE 0
    cvti2f f1, f1 ;; INDICE 0
    sw lista_tamanho,r9 ;; INDICE 0

    mult r13,r6,r7 ;; vMax * vT

    div r15,r11,r6 ;; 1 / vMax
    movi2fp f2, r13 ;; INDICE 1
    sw     secuencia_valor_medio, r10 ;; Guardar el valor medio de la secuencia
    cvti2f f2, f2 ;; INDICE 1
    div r16,r11,r10 ;; 1 / vMed

    mult r14,r10,r7 ;; vMed * vT

    movi2fp f3, r14 ;; INDICE 2
    cvti2f f3, f3 ;; INDICE 2

    sf lista,f1 ;; INDICE 0
    ;; Desplazamiento

    addi r21,r0,4 ;; INDICE 1
    mult r22,r21,r9 ;; INDICE 1
    addi r9,r9,1 ;; INDICE 1
    sw lista_tamanho,r9 ;; INDICE 1

    div r17,r11,r1 ;; 1 / vIni

;; ===================================== INDICE 0 =====================================


;; ===================================== INDICE 1 =====================================
    ;; Desplazamiento
    addi r21,r0,4 ;; INDICE 3
    mult r23,r21,r9 ;; INDICE 3
    addi r9,r9,1 ;; INDICE 2
    sw lista_tamanho,r9 ;; INDICE 2
    addi r21,r0,4 ;; INDICE 3
    mult r25,r21,r9 ;; INDICE 3
    sf lista(r22),f2
;; ===================================== INDICE 2 =====================================
    mult r24,r12,r15;; INDICE 3
    movi2fp f4, r24;; INDICE 3

    cvti2f f4, f4;; INDICE 3

    sf lista(r23),f3;; INDICE 3
;; ===================================== INDICE 3 =====================================
    


    addi r9,r9,1

    sw lista_tamanho,r9

    sf lista(r25),f4
;; ===================================== INDICE 4 ===================================== 
    trap 0