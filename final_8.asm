; Se ingresa una matriz de NxN componentes enteras. La computadora muestra la matriz transpuesta.
;
; En Windows:
; 1) nasm -f win32 final_7.asm --PREFIX _
; 2) gcc final_7.obj -o final_7.exe
; 3) final_7



        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)

cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)

matriz:
	resd	100		 ;  matriz como maximo de 10x10
		
n:
	resd	1		 ;  lado de la matriz (cuadrada)

f:
	resd	1		 ; fila
		
c:
	resd	1		 ; columna



section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

nStr:
	db    "N: ", 0		 ; Cadena "N: "

filaStr:
	db    "Fila:", 0	 ;  Cadena "Fila:"
	
columnaStr:
	db    " Columna:", 0	 ;  Cadena "Columna:"

cadenaStr:
        db    "Matriz Original: ", 0  


cadenaStr2:
        db    "Matriz Transpuesta: ", 0  




section .text                    ; SECCION DE LAS INSTRUCCIONES
 
leerCadena:                      ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push cadena
        call gets
        add esp, 4
        ret

leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
    
mostrarCadena:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret

mostrarNumero:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarCaracter:                 ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
        push dword [caracter]
        push fmtChar
        call printf
        add esp, 8
        ret

mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit





_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
	mov esi, 0
	mov ebx, 0

copiaAcadena1:			 
	mov al, [ebx+nStr]	 ; IMPRIME NSTR HASTA LLEGAR A FIN DE LINEA (0) Y LEE NUMERO
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena1
	call mostrarCadena
	call leerNumero
		
	mov eax, [numero]	 ; VALIDA QUE NUMERO INGRESADO SEA MAYOR A 0
	cmp eax, 0
	jg seguir1
	jmp main

seguir1:			 ; VALIDA QUE NUMERO INGRESADO SEA MENOR QUE 11
	cmp eax, 11
	jl seguir2
	jmp main

seguir2:			 ; MUEVE A N EL VALOR DE EAX (NUMERO)	
	mov [n], eax
		
	mov [f], dword 0 	 ; MUEBE A F EL VALOR 0

proximoF:
	mov [c], dword 0 	 ; MUEVE A C EL VALOR 0

proximoC:
	mov ebx, 0 		 ; PONE A EBX EN 0 (CONTADOR)

copiaAcadena2:
	mov al, [ebx+filaStr] 	 ; IMPRIME FILA HASTA LLEGAR A FIN DE LINEA(0) Y LEE NUMERO
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena2
	call mostrarCadena
		
	mov eax, [f]		 ; MUEVE A EAX EL VALOR DE F 
	mov [numero], eax	 ; MUEVE A NUMERO EL VALOR DE EAX 
	call mostrarNumero
	
	mov ebx, 0 		 ; PONGO EBX EN 0 (CONTADOR)

copiaAcadena3:
	mov al, [ebx+columnaStr] ; IMPRIME COLUMNA HASTA LLEGAR A FIN DE LINEA(0) Y LEE NUMERO
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena3
	call mostrarCadena

	mov eax, [c] 		 ; MUEVE A EAX EL VALOR DE C 
	mov [numero], eax	 ; MUEVE A NUMERO EL VALOR DE EAX 
	call mostrarNumero


	mov eax, 32 		 ; MUEVE 32 A EAX (ESPACIO)
	mov [caracter], eax 	 
	call mostrarCaracter
	call mostrarCaracter
	call leerNumero
	mov eax, [numero]	 ; MUEVO A EAX EL VALOR DE NUMERO
	mov [esi+matriz], eax 	 ; MUEVO AL INDICE EL VALOR DE EAX
	add esi, 4 		 ; AVANZO EN 4 POSICIONES 
		
	inc dword [c] 		 ; VOY AVANZANDO EN COLUMNAS
	mov eax, [c] 		 ; EN EAX GUARDO EL VALOR DE C
	cmp eax, [n] 		 ; COMPARO EL VALOR DE N CON C
	jb proximoC 		 ; PRIMERO ITERO POR COLUMNAS
		
	inc dword [f] 		 ; VOY AVANZANDO EN FILAS
	mov eax, [f]		 ; EN EAX GUARDO EL VALOR DE C
	cmp eax, [n] 		 ; COMPARO EL VALOR DE N CON C
	jb proximoF 		 ; LUEGO ITERO POR FILAS 



  
        mov ebx, 0   		; EMPIEZO CON IMPRESION DE MATRIZ ORIGINAL
        call mostrarSaltoDeLinea

copiaAcadena4:			; IMPRIMO CARACTERES "MATRIZ ORIGINAL"
        mov al, [ebx+cadenaStr]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena4
        call mostrarCadena

        call mostrarSaltoDeLinea

recorroMatriz:
	mov esi, 0		 ; CONTADOR FILAS

muestroFila:
	mov edi, 0 		 ; CONTADOR DE COLUMNAS

muestroColumna:

	mov ebx, esi 		 ; GUARDO EN EBX EL VALOR DE ESI
	imul ebx, [n] 		 ; MULTIPLICO EBX POR N
	imul ebx, 4		 ; MULTIPLICO EBX POR 4

	mov edx, edi 		 ; MUEVO A EDX EL VALOR DE ESI
	imul edx, 4 		 ; MULTIPLICO EDX POR 4

	add ebx, edx 		 ; SUMO EBX Y EDX

	mov eax, 0 		 ; MUESTRO NUMERO
	mov eax, [ebx+matriz]	
	mov [numero], eax
	call mostrarNumero
	mov eax, 0 		 ; ESPACIO
	mov al, 32
	call mostrarCaracter

	inc edi 		 ; INCREMENTO EDI Y LO COMPARO CON C 
	cmp edi, dword [c]
	jl muestroColumna 

	inc esi 		 ; NCREMENTO ESI Y LO COMPARO CON F 
	call mostrarSaltoDeLinea
	cmp esi, dword [f] 		 
	jl muestroFila	




        mov ebx, 0   		; SIGO CON IMPRESION DE MATRIZ TRANSPUESTA
        call mostrarSaltoDeLinea

copiaAcadena5:			; IMPRIMO CARACTERES "MATRIZ TRANSPUESTA"
        mov al, [ebx+cadenaStr2]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena5
        call mostrarCadena
        
        call mostrarSaltoDeLinea


recorroMatrizTranspuesta:
	mov esi, 0		 ; CONTADOR FILAS

muestroFilaTranspuesta:
	mov edi, 0 		 ; CONTADOR DE COLUMNAS

muestroColumnaTranspuesta:

	mov ebx, edi 		 ; GUARDO EN EBX EL VALOR DE EDI
	imul ebx, [n] 		 ; MULTIPLICO EBX POR N
	imul ebx, 4		 ; MULTIPLICO EBX POR 4

	mov edx, esi 		 ; MUEVO A EDX EL VALOR DE ESI
	imul edx, 4 		 ; MULTIPLICO EDX POR 4

	add ebx, edx 		 ; SUMO EBX Y EDX

	mov eax, 0 		 ; MUESTRO NUMERO
	mov eax, [ebx+matriz]	
	mov [numero], eax
	call mostrarNumero
	mov eax, 0
	mov al, 32
	call mostrarCaracter

	inc edi 		 ; INCREMENTO EDI Y LO COMPARO CON C 
	cmp edi, dword [c]
	jl muestroColumnaTranspuesta 

	inc esi 		 ; NCREMENTO ESI Y LO COMPARO CON F 
	call mostrarSaltoDeLinea
	cmp esi, dword [f] 		 
	jl muestroFilaTranspuesta	



finPrograma:              
        jmp salirDelPrograma

