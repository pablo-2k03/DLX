	.data

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
lista_numeros:  .float  9.0

.text
.global main

main:

    lw		r1, valor_inicial ;; Cargar valor inicial en r1
    lf      f23,lista_numeros
    lw		r8, contador ;; Cargar contador en r21
    
    sw      secuencia_maximo,r0
    sw      contador,r0

    add		r2,r0,r1  ; r2 = N
	add		r3,r0,r2 ; r3 = A[N-1]
	add		r4,r0,r2 ; r4 = A[N]
	add 	r5,r0,3



loop:

    lw		r6, secuencia_maximo ;; Cargar máximo de la secuencia en r6
	lw		r7, secuencia_tamanho ;; Cargar tamaño de la secuencia en r7


	addi	r20, r7, 1 ;; Incrementar tamaño de la secuencia
    add		r8, r8, r3 ;; Sumar al contador el valor actual de la secuencia

    addi 	r24,r0,#4 ;; Cargar en r24 el valor inmediato 4
	mult	r25,r7,r24 ;; Multiplicar el tamaño de la secuencia por 4


    sw		secuencia_tamanho, r20 
    sw 		secuencia(r25), r3 
    sw		contador, r8 ;; Guardar contador en r8

    ;;Verificar si el valor actual es mayor al máximo
    slt r26, r3, r6 ;; Comprobar si r3 < r21, en caso afirmativo, r26 = 1
    beqz r26, maximo ;; Si r26 = 0, saltar a maximo

continua:
    subi    r6,r3,1
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

finish:
    ;; Calculamos el valor medio de la secuencia
    lw      r7, secuencia_tamanho ;; Cargar tamaño de la secuencia en r7

    movi2fp f0, r7
    cvti2f  f0,f0                ;; Pasamos a flotante el tamaño

    movi2fp f11,r8
    cvti2f  f11,f11                ;; Pasamos a flotante el contador

    lw      r3, secuencia_maximo ;; Cargar máximo de la secuencia en r3

    movi2fp f12, r3
    cvti2f  f12,f12              ;; Pasamos a flotante el máximo

    lw      r1, valor_inicial ;; Cargar valor inicial en r1

    movi2fp f5, r1
    cvti2f  f5,f5               ;; Pasamos el valor inicial a flotante

    divf		f10, f11, f0 ;; Dividir el contador por el tamaño de la secuencia
    sf          secuencia_valor_medio,f10

rellenar_lista:
;; Pasamos a flotante los valores de los registros necesarios para las
;; operaciones de la lista

;; ================== INDICE 0 =========================
;; vIni * vT

    multf   f2,f5,f0
    sf      lista,f2
    addf    f9,f9,f2

;; ================== INDICE 1 =========================
;; vMax * vT

    multf   f3,f12,f0
    sf      lista+4,f3
    addf    f9,f9,f3

;; ================== INDICE 2 =========================
;; vMed * vT

    multf   f4,f10,f0
    sf      lista+8,f4
    addf    f9,f9,f4

;; ================== INDICE 3 =========================
;; (vIni/vMax) * vT

    divf    f6,f5,f12
    multf   f7,f6,f0
    sf      lista+12,f7
    addf    f9,f9,f7

;; ================== INDICE 4 =========================
;; (vIni/vMed) * vT

    divf    f8,f5,f10
    multf   f13,f8,f0
    sf      lista+16,f13
    addf    f9,f9,f13

;; ================== INDICE 5 =========================
;; (vMax/vIni) * vT

    divf    f14,f12,f5
    multf   f15,f14,f0
    sf      lista+20,f15
    addf    f9,f9,f15

;; ================== INDICE 6 =========================
;; (vMax/vMed) * vT

    divf    f16,f12,f10
    multf   f17,f16,f0
    sf      lista+24,f17
    addf    f9,f9,f17

;; ================== INDICE 7 =========================
;; (vMed/vIni) * vT

    divf    f18,f10,f5
    multf   f19,f18,f0
    sf      lista+28,f19
    addf    f9,f9,f19

;; ================== INDICE 8 =========================
;; (vMed/vMax) * vT

    divf    f20,f10,f12
    multf   f21,f20,f0
    sf      lista+32,f21
    addf    f9,f9,f21


;; CALCULAMOS VALOR MEDIO DE LA LISTA

    divf    f22,f9,f23
    sf      lista_valor_medio,f22

;; FIN
trap 0    