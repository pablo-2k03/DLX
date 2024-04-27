	.data
PrintFormat:	.asciiz	"%d\n"
				.align	2
PrintPar:		.word	PrintFormat
PrintValue:		.space	4
;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN 
valor_inicial:	.word	66

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

    lw		r22, secuencia_maximo ;; Cargar máximo de la secuencia en r22
    ;;Guardar valor actual en la secuencia
	lw		r23, secuencia_tamanho ;; Cargar tamaño de la secuencia en r23
	addi 	r24,r0,#4 ;; Cargar en r24 el valor inmediato 4
	mult	r25,r23,r24 ;; Multiplicar el tamaño de la secuencia por 4

    ;;Incrementar el tamaño de la secuencia
	addi	r20, r23, 1 ;; Incrementar tamaño de la secuencia
    
    ;; Sumar al contador el valor actual de la secuencia
    lw		r21, contador ;; Cargar contador en r21
    add		r21, r21, r3 ;; Sumar al contador el valor actual de la secuencia
    sw		contador, r21 ;; Guardar contador en r21

    ;;Verificar si el valor actual es mayor al máximo
    slt r26, r3, r22 ;; Comprobar si r3 < r21, en caso afirmativo, r22 = 1
    sw 		secuencia(r25), r3 
	sw		secuencia_tamanho, r20 

     beqz r26, maximo ;; Si r22 = 0, saltar a maximo

continua:
    subi    r6,r3,1
    jal print
    beqz r6, finish
    andi r7,r3,1
    beqz r7, par
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
    lw		r30, secuencia_tamanho ;; Cargar tamaño de la secuencia en r30
    lw		r28, contador ;; Cargar contador en r31
    div		r29, r28, r30 ;; Dividir el contador por el tamaño de la secuencia
    sw		secuencia_valor_medio, r29 ;; Guardar el valor medio de la secuencia

rellenar_lista:
    ;; INDICE 0
	lw 		r20, valor_inicial ;; Cargar valor inicial en r20
	lw		r21, secuencia_tamanho ;; Cargar tamaño de la secuencia en r21


    mult     r22, r20, r21 ;; Multiplicar valor inicial por tamaño de la secuencia

    ;;Incremento del tamaño de la lista
	lw 		r24, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r24, r24, 1 ;; Incrementar tamaño de la lista

    sw 		lista_tamanho, r24 ;; Guardar tamaño de la lista
	sw 		lista, r22 ;; Guardar valor inicial en lista

    ; ===========================================================
    ;; INDICE 1

	lw		r23, secuencia_maximo ;; Cargar máximo de la secuencia en r23
	lw		r21, secuencia_tamanho ;; Cargar tamaño de la secuencia en r21

	mult 	r24, r23, r21 ;; Multiplicar máximo por tamaño de la secuencia
	
	;; Desplazamiento de 4
	lw 		r20, lista_tamanho ;; Cargar tamaño de la lista en r20
	addi 	r21,r0,#4

	mult 	r22, r20, r21 ;; Multiplicar tamaño de la lista por 4

	sw 		lista(r22), r24 ;; Guardar máximo en lista

	;;Incremento del tamaño de la lista
	addi 	r24, r20, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r24 ;; Guardar tamaño de la lista



	;; INDICE 2
	lw 		r20, secuencia_valor_medio ;; Cargar valor medio de la secuencia en r20
	lw		r21, secuencia_tamanho ;; Cargar tamaño de la secuencia en r21
	mult 	r22, r20, r21 ;; Multiplicar valor medio por tamaño de la secuencia

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4

	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4

    ;;Incremento del tamaño de la lista
	addi 	r24, r19, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r24 ;; Guardar tamaño de la lista

	sw 		lista(r18), r22 ;; Guardar valor medio en lista

	;; INDICE 3
	lw 		r20, valor_inicial ;; Cargar tamaño de la secuencia en r20
	movi2fp	f1,r20 ;; Cargar valor inicial en f1
	cvti2f 	f1, f1 ;; Convertir valor inicial a flotante

    lw 		r21, secuencia_maximo ;; Cargar máximo de la secuencia en r21
	movi2fp	f2,r21 ;; Cargar máximo en f2
	cvti2f 	f2, f2 ;; Convertir máximo a flotante

	divf 	f3, f1, f2 ;; (vIni / vMax)

    lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22
	movi2fp	f1,r22
	cvti2f 	f1, f1

	multf 	f4, f3, f1  ;; ((vIni / vMax) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4

    ;;Incremento del tamaño de la lista
	addi 	r1, r19, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	sw 		lista(r18), r24 ;; Guardar valor medio en lista



	;; INDICE 4
	lw 		r20, valor_inicial ;; Cargar tamaño de la secuencia en r20
	lw 		r21, secuencia_valor_medio ;; Cargar valor medio de la secuencia en r21
	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22

	movi2fp	f1,r20 ;; Cargar valor inicial en f1
	cvti2f 	f1, f1 ;; Convertir valor inicial a flotante

	movi2fp	f2,r21 ;; Cargar valor medio en f2
	cvti2f 	f2, f2 ;; Convertir valor medio a flotante

	divf 	f3, f1, f2 ;; (vIni / vMed)

	movi2fp	f1,r22
	cvti2f 	f1, f1

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4

	multf 	f4, f3, f1  ;; ((vIni / vMed) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	    ;;Incremento del tamaño de la lista
	addi 	r1, r19, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4



	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	;; INDICE 5
	lw 		r20, secuencia_maximo ;; Cargar tamaño de la secuencia en r20
	lw 		r21, valor_inicial ;; Cargar valor medio de la secuencia en r21

	movi2fp	f1,r20 ;; Cargar maximo en f1
	cvti2f 	f1, f1 ;; Convertir maximo a flotante
	movi2fp	f2,r21 ;; Cargar valor inical en f2
	cvti2f 	f2, f2 ;; Convertir valor inical a flotante

	divf 	f3, f1, f2 ;; (vMax / vIni)

	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22
	movi2fp	f1,r22
	cvti2f 	f1, f1

    ;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4

	multf 	f4, f3, f1  ;; ((vMax / vIni) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	addi 	r1, r19, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	;; INDICE 6
	lw 		r20, secuencia_maximo ;; Cargar tamaño de la secuencia en r20
	lw 		r29, secuencia_valor_medio ;; Cargar valor medio de la secuencia en r21
	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22

	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4

	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	movi2fp	f1,r20 ;; Cargar maximo en f1
	cvti2f 	f1, f1 ;; Convertir maximo a flotante

	movi2fp	f2,r29 ;; Cargar valor medio en f2
	cvti2f 	f2, f2 ;; Convertir valor medio a flotante

	divf 	f3, f1, f2 ;; (vMax / vMed)
	
	movi2fp	f1,r22
	cvti2f 	f1, f1

    ;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r29,r0,#4

	multf 	f4, f3, f1  ;; ((vMax / vMed) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

    	;;Incremento del tamaño de la lista
	lw 		r1, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r1, r1, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	mult 	r18, r19, r29 ;; Multiplicar tamaño de la lista por 4

	;; INDICE 7
	lw 		r20, secuencia_valor_medio ;; Cargar tamaño de la secuencia en r20
	lw 		r21, valor_inicial ;; Cargar valor medio de la secuencia en r21
	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22

	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	movi2fp	f1,r20 ;; Cargar valor medio en f1
	cvti2f 	f1, f1 ;; Convertir valor medio a flotante

	movi2fp	f2,r21 ;; Cargar valor inicial en f2
	cvti2f 	f2, f2 ;; Convertir valor inicial a flotante

	divf 	f3, f1, f2 ;; (vMed / vIni)
	movi2fp	f1,r22
	cvti2f 	f1, f1
	;; Desplazamiento de 4

	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4

	multf 	f4, f3, f1  ;; ((vMed / vIni) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;;Incremento del tamaño de la lista
	lw 		r1, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r1, r1, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4
	sw 		lista(r18), r24 ;; Guardar valor medio en lista


	;; INDICE 8
	lw 		r20, secuencia_valor_medio ;; Cargar tamaño de la secuencia en r20
	lw 		r21, secuencia_maximo ;; Cargar valor medio de la secuencia en r21

	movi2fp	f1,r20 ;; Cargar valor medio en f1
	cvti2f 	f1, f1 ;; Convertir valor medio a flotante
	movi2fp	f2,r21 ;; Cargar valor maximo en f2
	cvti2f 	f2, f2 ;; Convertir valor maximo a flotante

	divf 	f3, f1, f2 ;; (vMed / vMax)

	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22
	movi2fp	f1,r22
	cvti2f 	f1, f1

	multf 	f4, f3, f1  ;; ((vMed / vMax) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4

	;;Incremento del tamaño de la lista
	addi 	r1, r19, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista
	sw 		lista(r18), r24 ;; Guardar valor medio en lista
    trap 0