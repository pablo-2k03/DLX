	.data
PrintFormat:	.asciiz	"%d\n"
				.align	2
PrintPar:		.word	PrintFormat
PrintValue:		.space	4
;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN 
valor_inicial:	.word	3

;; VARIABLES DE SALIDA
secuencia:		.space	120*4
secuencia_tamanho:	.word	0
secuencia_maximo:	.word	0
secuencia_valor_medio:	.float	0
lista:			.space	9*4
lista_valor_medio:	.float	0
;; FIN VARIABLES DE ENTRADA Y SALIDA

;; Variables auxiliares
contador:		.word	0
lista_tamanho:	.word	0

				.text
				.global main
main:
	
	lw		r1, valor_inicial ;; Cargar valor inicial en r1
	sw		secuencia, r1	  ;; Guardar valor inicial en secuencia

	sw		secuencia_maximo, r0 ;; Inicializar máximo de la secuencia
	sw		contador, r0 ;; Inicializar contador
	sw		lista_tamanho, r0 ;; Inicializar tamaño de la lista
	sw 		secuencia_tamanho, r0 ;; Inicializar tamaño de la secuencia

	add		r2,r0,r1
	add		r3,r0,r2
	add		r4,r0,r2
	add 	r5,r0,3

loop:
    ;;Incrementar el tamaño de la secuencia
	lw		r20, secuencia_tamanho ;; Cargar tamaño de la secuencia en r20
	addi	r20, r20, 1 ;; Incrementar tamaño de la secuencia
	sw		secuencia_tamanho, r20 

	;;Incrementar el contador
	lw		r21, contador ;; Cargar contador en r20
	add 	r21, r21, r3  ;; Incrementamos en r21 el valor actual de r3
	sw		contador, r21 ;; Guardar contador

	;;Guardar valor actual en la secuencia
	lw		r23, secuencia_tamanho ;; Cargar tamaño de la secuencia en r23
	addi 	r24,r0,#4 ;; Cargar en r24 el valor inmediato 4
	mult	r25,r23,r24 ;; Multiplicar el tamaño de la secuencia por 4
	sw 		secuencia(r25), r3 ;; Guardar valor actual en la secuencia


	;;Verificar si el valor actual es mayor al máximo
	lw		r21, secuencia_maximo ;; Cargar máximo de la secuencia en r21
    slt r22, r3, r21 ;; Comprobar si r3 < r21, en caso afirmativo, r22 = 1
    beqz r22, maximo ;; Si r22 = 0, saltar a maximo
    
continua:
	subi	r6,r3,1
	jal	print
	beqz	r6,finish
	andi	r7,r3,1
	beqz	r7,par
	mult	r4,r3,r5
	addi	r4,r4,1
	add		r3,r4,r0
	j		loop


par:
	srli	r4,r3,1
	add		r3,r4,r0
	j		loop
print:
	sw 		PrintValue,r4
	addi	r14,r0,PrintPar
	trap	5
	jr	 	r31
maximo:
	sw		secuencia_maximo, r3 ;; Guardar valor actual como máximo
	j 		continua
finish:
	;;Calcular el valor medio de la secuencia
	lw		r20, secuencia_tamanho ;; Cargar tamaño de la secuencia en r20
	lw 		r21, contador ;; Cargar contador en r21
	div 	r13,r21,r20 ;; Calcular el valor medio
	sw 		secuencia_valor_medio, r13 ;; Guardar valor medio en secuencia_valor_medio


rellenar_lista:

	;; INDICE 0
	lw 		r20, valor_inicial ;; Cargar valor inicial en r20
	lw		r21, secuencia_tamanho ;; Cargar tamaño de la secuencia en r21

	mult 	r22,r20,r21 ;; Multiplicar valor inicial por tamaño de la secuencia

    ;;Incremento del tamaño de la lista
	lw 		r24, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r24, r24, 1 ;; Incrementar tamaño de la lista

    sw 		lista_tamanho, r24 ;; Guardar tamaño de la lista
	sw 		lista, r22 ;; Guardar valor inicial en lista
	

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


;;================================================================================================

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
	multf 	f4, f3, f1  ;; ((vIni / vMed) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4
	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	;;Incremento del tamaño de la lista
	lw 		r1, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r1, r1, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	;; INDICE 5
	lw 		r20, secuencia_maximo ;; Cargar tamaño de la secuencia en r20
	lw 		r21, valor_inicial ;; Cargar valor medio de la secuencia en r21
	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22

	movi2fp	f1,r20 ;; Cargar maximo en f1
	cvti2f 	f1, f1 ;; Convertir maximo a flotante
	movi2fp	f2,r21 ;; Cargar valor inical en f2
	cvti2f 	f2, f2 ;; Convertir valor inical a flotante

	divf 	f3, f1, f2 ;; (vMax / vIni)
	movi2fp	f1,r22
	cvti2f 	f1, f1
	multf 	f4, f3, f1  ;; ((vMax / vIni) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4
	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	;;Incremento del tamaño de la lista
	lw 		r1, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r1, r1, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	;; INDICE 6
	lw 		r20, secuencia_maximo ;; Cargar tamaño de la secuencia en r20
	lw 		r21, secuencia_valor_medio ;; Cargar valor medio de la secuencia en r21
	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22

	movi2fp	f1,r20 ;; Cargar maximo en f1
	cvti2f 	f1, f1 ;; Convertir maximo a flotante
	movi2fp	f2,r21 ;; Cargar valor medio en f2
	cvti2f 	f2, f2 ;; Convertir valor medio a flotante

	divf 	f3, f1, f2 ;; (vMax / vMed)
	movi2fp	f1,r22
	cvti2f 	f1, f1
	multf 	f4, f3, f1  ;; ((vMax / vMed) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4
	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	;;Incremento del tamaño de la lista
	lw 		r1, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r1, r1, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	;; INDICE 7
	lw 		r20, secuencia_valor_medio ;; Cargar tamaño de la secuencia en r20
	lw 		r21, valor_inicial ;; Cargar valor medio de la secuencia en r21
	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22

	movi2fp	f1,r20 ;; Cargar valor medio en f1
	cvti2f 	f1, f1 ;; Convertir valor medio a flotante
	movi2fp	f2,r21 ;; Cargar valor inicial en f2
	cvti2f 	f2, f2 ;; Convertir valor inicial a flotante

	divf 	f3, f1, f2 ;; (vMed / vIni)
	movi2fp	f1,r22
	cvti2f 	f1, f1
	multf 	f4, f3, f1  ;; ((vMed / vIni) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4
	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	;;Incremento del tamaño de la lista
	lw 		r1, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r1, r1, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista

	;; INDICE 8
	lw 		r20, secuencia_valor_medio ;; Cargar tamaño de la secuencia en r20
	lw 		r21, secuencia_maximo ;; Cargar valor medio de la secuencia en r21
	lw		r22, secuencia_tamanho ;; Cargar tamaño de la secuencia en r22

	movi2fp	f1,r20 ;; Cargar valor medio en f1
	cvti2f 	f1, f1 ;; Convertir valor medio a flotante
	movi2fp	f2,r21 ;; Cargar valor maximo en f2
	cvti2f 	f2, f2 ;; Convertir valor maximo a flotante

	divf 	f3, f1, f2 ;; (vMed / vMax)
	movi2fp	f1,r22
	cvti2f 	f1, f1
	multf 	f4, f3, f1  ;; ((vMed / vMax) * vT)

	cvtf2i 	f4, f4 ;; Convertir resultado del registro f4 a entero
	movfp2i	r24,f4 ;; Guardar resultado operación en r24

	;; Desplazamiento de 4
	lw 		r19, lista_tamanho ;; Cargar tamaño de la lista en r19
	addi 	r21,r0,#4
	mult 	r18, r19, r21 ;; Multiplicar tamaño de la lista por 4
	sw 		lista(r18), r24 ;; Guardar valor medio en lista

	;;Incremento del tamaño de la lista
	lw 		r1, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r1, r1, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r1 ;; Guardar tamaño de la lista
acabar:
	trap	0