; Se ingresan 100 caracteres. La computadora los muestra ordenados sin repeticiones.
;
; En Windows:
; 1) nasm -f win32 final_5.asm --PREFIX _
; 2) gcc final_5.obj -o final_5.exe
; 3) final_5



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

cadenaInicio:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)





section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

cadenaStr:
        db    "Ingrese una cadena de 100 caracteres: ", 0  

cadenaError:
        db    "Debe ingresar 100 caracteres. Vuelva a empezar!!!", 0  


indices:	
		dw  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

caracteres:	
		db  "!",34,"#$%&",39,"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 0




section .text                           ; SECCION DE LAS INSTRUCCIONES
 
leerCadena:                             ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push cadena
        call gets
        add esp, 4
        ret

leerNumero:                             ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
    
mostrarCadena:                          ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret

mostrarCadenaInicio:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadenaInicio
        push fmtString
        call printf
        add esp, 8
        ret

mostrarCadenaError:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadenaError
        push fmtString
        call printf
        add esp, 8
        ret

mostrarNumero:                          ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarCaracter:                        ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
        push dword [caracter]
        push fmtChar
        call printf
        add esp, 8
        ret

mostrarSaltoDeLinea:                    ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

salirDelPrograma:                       ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit




_start:
main:                                   ; PUNTO DE INICIO DEL PROGRAMA        
        mov ebx, 0  

copiaAcadena:                           ; MUESTRO CADENA "INGRESE 100 CARACTERES"
        mov al, [ebx+cadenaStr]
        mov [ebx+cadenaInicio], al
        inc ebx
        cmp al, 0
        jne copiaAcadena
        call mostrarCadenaInicio

        call leerCadena                 ; LEO CADENA
        mov edi, 0

seguir1:                                ; SI LA CADENA ES IGUAL A 100 AVANZO, SI NO LA VUELVO A PEDIR
        mov al,[edi + cadena]
        inc edi
        cmp al, 0
        jne seguir1
        cmp edi, 101
        je avanzo
        mov ebx, 0 
        call mostrarSaltoDeLinea

copiaAcadena2:                          ; MUESTRO CADENA DE ERROR "INGRESE NUEVAMENTE..."
        mov al, [ebx+cadenaError]
        mov [ebx+cadenaError], al
        inc ebx
        cmp al, 0
        jne copiaAcadena2
        call mostrarCadenaError
        call mostrarSaltoDeLinea
        jmp copiaAcadena

avanzo:
        mov edi, 0
        mov esi, 0
        mov eax, 0 

seguir:
        mov al,[edi + cadena]
        cmp al, 0
        mov esi, -1                     ; DEJO ESI EN -1 PARA QUE EL LOOP LO ARRANQUE EN 0
        je salto


dejar:                        
	cmp al, [esi + caracteres]	; COMPARO AL CON CADA CARACTER DEL ARRAY DE CARACTERES VALIDOS
	jne siguiente			; SI NO ESTA EN LA LISTA SALTO AL SIGUIENTE CARACTER
	inc byte [esi + indices]	; SI LA ENCONTRE INCREMENTO EN EL ARRAY DE CANTIDADES, LA CANTIDAD DE VECES QUE APARECIO ESE CARACTER


        inc edi                         ; SIGO LEYENDO
        jmp seguir 

siguiente:
        inc esi                         ; INCREMENTO EL INDICE DEL ARRAY DE CARACTERES VALIDOS
        jmp dejar

salto:
	call mostrarSaltoDeLinea

imprimir:
	inc esi				; VIENE EN -1 POR ESO LO PONGO EN 0
	mov al, byte [esi + indices]	; OBTENGO LA CANTIDAD DE VECES QUE SE IMPRIMIO EL CARACTER ACTUAL
	cmp al, 0 			; ME QUEDO SOLO CON LOS QUE APARECIERON AL MENOS 1 VEZ
	je validaArray					
		

        mov al, byte[esi + caracteres]	; PONGO EN AL EL CARACTER A IMPRIMIR
        mov [caracter], al 				
        call mostrarCaracter

validaArray:        
        cmp esi, 95			; SI RECORRI EL ARRAY DE INDICES VOY AL FINAL SINO SIGO RECORRIENDO
        jb imprimir 


finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma
