	.data

;; VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN 
valor_inicial:	        .word	97

;; VARIABLES DE SALIDA
secuencia:		        .space	120*4
secuencia_tamanho:	    .word	0
secuencia_maximo:	    .word	0
secuencia_valor_medio:	.float	0
lista:			        .space	9*4
lista_valor_medio:	    .float	0

;; Otras variables
contador:		        .word	0
lista_tamanho:	        .word	0
lista_numeros:          .float  9.0  
valor_uno:              .float  1.0

.text
.global main

main:

    lw		r1, valor_inicial       ;; Cargar valor inicial en r1
    lw		r7, secuencia_tamanho   ;; Cargar tamaño de la secuencia en r7
    lw		r8, contador            ;; Cargar contador en r21
    lw      r11, secuencia_maximo   ;; En r11 esta el valor maximo inicial = 0
    lf      f23, lista_numeros      ;; Cargar valor 9.0 en f23

    add		r2,r0,r1                ;; r2 = N
	add		r3,r0,r2                ;; r3 = A[N-1]
	add		r4,r0,r2                ;; r4 = A[N]

loop:

    add		r8, r8, r3              ;; Sumar al contador el valor actual de la secuencia
    addi	r7, r7, 1               ;; Incrementar tamaño de la secuencia

    sw 		secuencia(r24), r3      ;; Almacenamos el valor actual en la secuencia
    slli    r24, r7, 2              ;; Multiplicar el tamaño de la secuencia por 4 (desplazamiento de bits)
    
    ;;Verificamos si el valor actual es mayor al máximo
    slt r26, r3, r11                ;; Comprobar si r3 < r11 (vActual < secMax), en caso afirmativo r26=1
    sw	contador, r8                ;; Guardar contador en r8
    beqz r26, maximo                ;; Si r26 = 0, saltar a maximo

continua:
    subi r6,r3,1                    ;; R6 <-- R3 (valorActual) - 1 
    andi r27,r3,1                   ;; R27 <-- R3 + 1  (valorActual + 1)
    beqz r6, finish                 ;; Si R6 (valorActual -1) = 0, acaba
    beqz r27, par                   ;; Si R27 (valorActual + 1) = 0, saltar a par

    add r22, r3, r3                 ;; R22 <-- R3 + R3
    add r4, r22, r3                 ;; R4 <-- R22 + R3
    addi r4,r4,1                    ;; R4 <-- R4 + 1
    add r3,r4,r0
    j loop
par:
    srli r4,r3,1                    ;; R4 <-- R3 >> 1 (R4 = R3 / 2)
    add r3,r4,r0                    ;; R3 <-- R4 + R0 (R3 = R4)
    j loop
maximo:
	sw	secuencia_maximo, r3        ;; Guardar valor actual como máximo
    lw  r11, secuencia_maximo       ;; Cargar la secuencia máxima en R11
    j continua

finish:
    ;; Calculamos el valor medio de la secuencia
    lf f25, valor_uno               ;; En f25 tenemos 1.0

    movi2fp f0, r7                  ;; Mueve el valor de R7 a F0
    movi2fp f11,r8                  ;; Mueve el valor de R8 a F11
    cvti2f  f0,f0                   ;; Pasamos a flotante el tamaño
    cvti2f  f11,f11                 ;; Pasamos a flotante el contador

    lw      r3, secuencia_maximo    ;; Cargar máximo de la secuencia en r3
    divf	f10, f11, f0            ;; Dividir el contador por el tamaño de la secuencia

    movi2fp f12, r3                 ;; Mueve el valor de R3 a F12

    cvti2f  f12,f12                 ;; Convertimos a flotante el valor máximo


    movi2fp f5, r1                  ;; Mueve el valor de R1 a F5
    cvti2f  f5,f5                   ;; Convertimos el valor inicial a flotante

    multf   f2,f5,f0                ;; Correspondiente a INDICE 0 F2 <-- F5 (vIni) * F0 (tamaño)


rellenar_lista:
;; Pasamos a flotante los valores de los registros necesarios para las
;; operaciones de la lista

;; ================== INDICE 0 =========================
;; vIni * vT
    divf f6, f25,f12                ;; F6 = 1.0/vMax(f12)  

    sf      lista,f2                ;; lista[0] = vIni * vT
    addf    f9,f9,f2                ;; acumulador <-- acumulador + (vIni * vT)

;; ================== INDICE 1 =========================
;; vMax * vT
    multf   f3,f12,f0               ;; Correspondiente a INDICE 1 F3 <-- F12 (vMax) * F0 (vT)
    divf    f8,f25,f10              ;; F8= 1.0/vMed(f10) 

    sf      lista+4,f3              ;; lista[1] = vMax * vT    
    sf      secuencia_valor_medio,f10 
    multf   f4,f10,f0               ;; Correspondiente a INDICE 2 F4 <-- F10 (vMed) * F0 (vT)

    addf    f9,f9,f3                ;; acumulador <-- acumulador + (vMax * vT)

;; ================== INDICE 2 =========================
;; vMed * vT

    sf      lista+8,f4              ;; lista[2] = vMed * vT
    addf    f9,f9,f4                ;; acumulador <-- acumulador + (vMed * vT)

;; ================== INDICE 3 =========================
;; (vIni/vMax) * vT

;; Para optimizar ciclos y reducir divisones se hace lo siguiente

    multf   f7,f6,f2                ;; Correspondiente a INDICE 3  F7 <-- F6 (1.0/vMax) * F2 (vIni * vT)

    divf    f14,f25,f5              ;; F14= 1.0/vIni(f5)



;; ================== INDICE 4 =========================
;; (vIni/vMed) * vT

    multf   f13,f8,f2               ;; Correspondiente a INDICE 4  F13 <-- F8 (1.0/vMed) * F2 (vIni * vT)
    sf      lista+12,f7             ;; lista[3] = (vIni/vMax) * vT
    addf    f9,f9,f7                ;; acumulador <-- acumulador + (vIni/vMax) * vT
    multf   f15,f14,f3              ;; Correspondiente a INDICE 5  F15 <-- F14 (1.0/vIni) * F3 (vMax * vT)

    sf      lista+16,f13            ;; lista[4] = (vIni/vMed) * vT
    addf    f9,f9,f13               ;; acumulador <-- acumulador + (vIni/vMed) * vT

;; ================== INDICE 5 =========================
;; (vMax/vIni) * vT



;; ================== INDICE 6 =========================
;; (vMax/vMed) * vT

    multf   f17,f8,f3               ;; F17 <-- F8 (1.0/vMed) * F3 (vMax * vT)
    sf      lista+20,f15            ;; lista[5] = (vMax/vIni) * vT
    addf    f9,f9,f15               ;; acumulador <-- acumulador + (vMax/vIni) * vT
    multf   f19,f14,f4              ;; Correspondiente a INDICE 7  F19 <-- F14 (1.0/vIni) * F4 (vMed * vT)

    sf      lista+24,f17            ;; lista[6] = (vMax/vMed) * vT
    addf    f9,f9,f17               ;; acumulador <-- acumulador + (vMax/vMed) * vT

;; ================== INDICE 7 =========================
;; (vMed/vIni) * vT



;; ================== INDICE 8 =========================
;; (vMed/vMax) * vT

    multf   f21,f6,f4               ;; F21 <-- F6 (1.0/vMax) * F4 (vMed * vT)
    sf      lista+28,f19            ;; lista[7] = (vMed/vIni) * vT
    addf    f9,f9,f19               ;; acumulador <-- acumulador + (vMed/vIni) * vT
    sf      lista+32,f21            ;; lista[8] = (vMed/vMax) * vT
    addf    f9,f9,f21               ;; acumulador <-- acumulador + (vMed/vMax) * vT)
    

;; CALCULAMOS VALOR MEDIO DE LA LISTA

    divf    f22,f9,f23              ;; F22 <-- F9 (acumulador) / F23 (9.0)
    sf      lista_valor_medio,f22   ;; lista_valor_medio <-- F22

;; FIN
trap 0    