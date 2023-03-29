; Se ingresa N. La computadora muestra los primeros N términos de la Secuencia de Connell.
;
; En Windows:
; 1) nasm -f win32 final_6.asm --PREFIX _
; 2) gcc final_6.obj -o final_6.exe
; 3) final_6



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

divisor:                        
        dd    2                  ; Declaro a 2 como divisor 

total:                        
        dd    0                  ; Declaro a 2 como divisor 


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

        mov dword [cadena], "N: "       ; PIDO N
        call mostrarCadena
        call leerNumero                 ; LEO N
        mov edx, [numero]        
        mov [total], edx                ; GUARDO LA CANTIDAD TOTAL DE ITERACIONES (N)

        mov edx, 0                      ; INICIALIZO LOS REGISTROS POR UNICA VEZ
        mov ecx, 0


primeraMult:
        mov edi, 1                      ; INICIALIZO LOS CONTADORES POR CADA ITERACION DEL LOOP
        mov esi, -1

        inc edx                         ; ACTUALIZO ITERACIONES            
        mov ecx, edx
        imul ecx, ecx, 2                ; CALCULO 2*N


operacionDentroRaiz:
        mov eax, edx 
        imul eax, 8                     ; 8*N
        sub eax, 7                      ; (8*N)-7


raiz:
        sub eax, edi                    ; RAIZ VOY RESTANDO IMPARES Y CONTANDO EN ESI

        add edi, 2
        inc esi

        cmp eax, 0
        jge raiz

suma:
    
        add esi, 1                      ; 1+RAIZ((8*N)-7)


segundaMult:

        mov ebx, [divisor]              ; DIVIDO EL CORCHETE POR 2 Y ME QUEDO POR LA PARTE ENTERA
        mov eax, esi            
        push edx
        mov edx, 0
        idiv ebx
        pop edx

operacionFinal:

        sub ecx, eax                    ; 2*N - CORCHETE

secuenciaConell:

        push eax                        ; PRESERVO REGISTROS
        push ecx 
        push edx         
        mov [numero], ecx               ; IMPRIMO NUMERO ACTUAL DE SECUENCIA DE CONELL
        call mostrarNumero
        call mostrarSaltoDeLinea
        pop edx                         ; RESTAURO REGISTROS
        pop ecx
        pop eax

        cmp edx, [total]                ; SI YA HICE TODAS LAS ITERACIONES SALGO O SINO VUELVO A EMPEZAR
        jl primeraMult
        je finPrograma

        
finPrograma:              
        jmp salirDelPrograma




