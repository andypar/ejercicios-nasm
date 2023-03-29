; Se ingresan un entero N y, a continuación, N números enteros. La computadora muestra el promedio de los números impares ingresados y la suma de los pares.
;
; En Windows:
; 1) nasm -f win32 final_4.asm --PREFIX _
; 2) gcc final_4.obj -o final_4.exe
; 3) final_4


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
        db    "N: ", 0           ; Cadena "N: "

pidoNStr:
        db    "Ingrese un numero: ", 0     ;  Cadena 

pidoNStr2:
        db    "Suma de los numeros pares: ", 0     ;  Cadena 

pidoNStr3:
        db    "Promedio de los numeros impares: ", 0     ;  Cadena 



section .text                    ; SECCION DE LAS INSTRUCCIONES


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

mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret


salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit




_start:
main:                                   ; PUNTO DE INICIO DEL PROGRAMA
	mov edi, 0
	mov esi, 0

pidoN:
        mov dword [cadena], "N: "       ; PIDO "N: "
        call mostrarCadena
        call leerNumero                 ; LEO N

        mov eax, [numero]
        
        mov ecx, 0                      ; LAS LLAMADAS EXTERNAS PUEDEN PISAR EAX, ECX, EDX             
        mov edx, 0                      ; LAS LLAMADAS EXTERNAS PUEDEN PISAR EAX, ECX, EDX 


pidoNumeros:    
        push eax                        ; PRESERVO EL VALOR DE EAX DE LOS SYSTEM CALLS
        push ecx                        ; PRESERVO EL VALOR DE ECX DE LOS SYSTEM CALLS        
        push edx                        ; PRESERVO EL VALOR DE EDX DE LOS SYSTEM CALLS  
        mov ebx, 0

 copiaAcadena:
        mov al, [ebx+pidoNStr]          ; IMPRIMO CADENA PIDIENDO LOS N NUMEROS SIGUIENTES
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena
        call mostrarCadena
        call leerNumero

        pop edx                         ; RESTAURO EL VALOR DE EDX
        pop ecx                         ; RESTAURO EL VALOR DE ECX

        mov eax, [numero]
        
        test al, 1                      ; EVALUO SI ES PAR O IMPAR
        pop eax                         ; RESTAURO EL VALOR DE EAX

        jnz impares                     ; SI NO ES CERO, ES IMPAR
        jz pares                        ; SI ES CERO, ES PAR

pares:
       	add ecx, [numero]               ; SI SON PARES LOS ACUMULO EN ECX
       	jmp continua


impares:
       	add edx, [numero]               ; SI SON IMPARES LOS ACUMULO EN EDX
       	inc esi                         ; CONTADOR PARA PROMEDIO
       	jmp continua


continua:
        inc edi 
        cmp edi, eax
        jl pidoNumeros                  ; SIGO PIDIENDO NUMEROS HASTA LLEGAR A N


muestroAcum:
        mov [numero], ecx

        push eax                        ; PRESERVO EL VALOR DE EAX DE LOS SYSTEM CALLS
        push ecx                        ; PRESERVO EL VALOR DE ECX DE LOS SYSTEM CALLS        
        push edx                        ; PRESERVO EL VALOR DE EDX DE LOS SYSTEM CALLS                

        mov ebx, 0
        call mostrarSaltoDeLinea

 copiaAcadena2:                         ; MUESTRO CADENA "SUMA DE LOS PARES"
        mov al, [ebx+pidoNStr2]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena2
        call mostrarCadena

        call mostrarNumero              ; MUESTRO NUMERO

        pop edx                         ; RESTAURO EL VALOR DE EAX
        pop ecx                         ; RESTAURO EL VALOR DE EAX
        pop eax                         ; RESTAURO EL VALOR DE EAX


muestroProm:
        cmp esi, 0
        je todosPares                   ; SI ESI ES IGUAL A 0 ES QUE NO TUVE IMPARES

        mov eax, edx
        mov edx, 0 
        idiv esi                        ; CALCULO PROMEDIO (DIVIDO POR ESI)
        mov [numero], eax

        mov ebx, 0
        call mostrarSaltoDeLinea

 copiaAcadena3:                         ; MUESTRO CADENA "PROMEDIO DE LOS IMPARES"
        mov al, [ebx+pidoNStr3]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena3
        call mostrarCadena

        call mostrarNumero              ; MUESTRO NUMERO
        jmp finPrograma

todosPares:                             ; SI RECIBO SOLO PARES DEJO EL PROM EN 0
        mov eax, 0
        mov [numero], eax 

        mov ebx, 0
        call mostrarSaltoDeLinea

 copiaAcadena4:                         ; MUESTRO CADENA "PROMEDIO DE LOS IMPARES"
        mov al, [ebx+pidoNStr3]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena4
        call mostrarCadena

        call mostrarNumero              ; MUESTRO NUMERO

finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma

