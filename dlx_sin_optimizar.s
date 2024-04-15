	.data
PrintFormat:	.asciiz	"%d\n"
				.align	2
PrintPar:		.word	PrintFormat
PrintValue:		.space	4
;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN 
valor_inicial:	.word	3

;; Variables de salida
secuencia:		.space	120*4
secuencia_tamanho:	.word	0
secuencia_maximo:	.word	0
secuencia_valor_medio:	.float	0
lista:			.space	9*4
lista_valor_medio:	.float	0
;; Fin de variables de entrada y salida

;; Variables auxiliares
contador:		.word	0
lista_tamanho:	.word	0
				.text
				.global main
main:
	
	lw		r1, valor_inicial ;; Cargar valor inicial en r1
	sw		secuencia, r1	  ;; Guardar valor inicial en secuencia

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
	sgtu 	r22, r3, r21 ;; r22 es 1 si r3 > r21
	subi 	r22, r22, 1 ;; Le restamos 1 a r22 para que sea 0 si r3 > r21
	beqz	r22, maximo ;; Saltar a maximo si r3 > r21

	subi	r6,r3,1
	jal	print
	beqz	r6,finish
	andi	r7,r3,1
	beqz	r7,par
	mult	r4,r3,r5
	addi	r4,r4,1
	add		r3,r4,r0
	j		loop

loop2:
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
	j 		loop2
finish:
	;;Calcular el valor medio de la secuencia
	lw		r20, secuencia_tamanho ;; Cargar tamaño de la secuencia en r20
	lw 		r21, contador ;; Cargar contador en r21
	div 	r13,r21,r20 ;; Calcular el valor medio
	sw 		secuencia_valor_medio, r13 ;; Guardar valor medio en secuencia_valor_medio
	j 		rellenar_lista


rellenar_lista:

	lw 		r20, valor_inicial ;; Cargar valor inicial en r20
	lw		r21, secuencia_tamanho ;; Cargar tamaño de la secuencia en r21
	mult 	r22,r20,r21 ;; Multiplicar valor inicial por tamaño de la secuencia
	sw 		lista, r22 ;; Guardar valor inicial en lista
	
	;;Incremento del tamaño de la lista
	lw 		r24, lista_tamanho ;; Cargar tamaño de la lista en r24
	addi 	r24, r24, 1 ;; Incrementar tamaño de la lista
	sw 		lista_tamanho, r24 ;; Guardar tamaño de la lista

	lw		r23, secuencia_maximo ;; Cargar máximo de la secuencia en r23
	lw		r21, secuencia_tamanho ;; Cargar tamaño de la secuencia en r21
	mult 	r24, r23, r21 ;; Multiplicar máximo por tamaño de la secuencia
	
	lw 		r20, lista_tamanho ;; Cargar tamaño de la lista en r20
	addi 	r21,r0,#4
	mult 	r22, r20, r21 ;; Multiplicar tamaño de la lista por 4
	sw 		lista(r22), r24 ;; Guardar máximo en lista


acabar:
	trap	0