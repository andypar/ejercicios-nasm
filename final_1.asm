; Dado un entero N, la computadora lo muestra descompuesto en sus factores primos. Ej: 132 = 2 × 2 × 3 × 11
;
; En Windows:
; 1) nasm -f win32 final_1.asm --PREFIX _
; 2) gcc final_1.obj -o final_1.exe
; 3) final_1


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

mostrarDivisor:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [divisor]
        push fmtInt
        call printf
        add esp, 8
        ret        


mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

modulo:                         ; calcs eax mod ebx, returns eax
        mov edx, 0              ; clear higher 32-bits as edx:eax / ebx is calced
        idiv ebx                ; divide the contents of EDX:EAX by the contents of EBX. Place the quotient in EAX and the remainder in EDX.
        ret

muestraFactor:
        call mostrarNumero
        mov dword [cadena], " = "
        call mostrarCadena 
        ret


salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit



_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA

        mov word [cadena], "N:"  ; PIDO N
        call mostrarCadena
        call leerNumero

        mov eax, [numero]       ; EN EAX QUEDA N
        mov ebx, [divisor]      ; EN EBX QUEDA DIVISOR (2)
        push eax                ; PRESERVO EL VALOR DE EAX DE LOS SYSTEM CALLS
        call muestraFactor
        pop eax                 ; RESTAURO EL VALOR DE EAX

While:                         
        cmp eax, ebx            ; COMPARO EAX CON EBX    
        je Iguales              ; SI SON IGUALES SALTO A IGUALES
        jle finPrograma         ; SI ES MENOR O IGUAL SALTO A FIN DE PROGRAMA

        push eax                ; PRESERVO EL VALOR DE EAX DE LOS SYSTEM CALLS
        call modulo             ; FUNCION MODULO: DEJA RESTO EN EDX
        cmp edx, 0              ; COMPARO EDX CON 0
        jne Else
        add esp, 4              ; DESCARTO EL TOPE DE LA PILA DONDE DEJE EAX
        push eax                ; PRESERVO EL VALOR DE EAX DE LOS SYSTEM CALLS
        call mostrarDivisor     ; SI EL RESTO ES CERO MUESTRA EL FACTOR


        mov dword [cadena], " x "
        call mostrarCadena
        pop eax                 ; RESTAURO EL VALOR DE EAX
        jmp While               ; VUELVO AL WHILE DE ARRIBA

Else:
        pop eax                 ; RESTAURO EL VALOR DE EAX
        inc ebx                 ; INCREMENTO EL DIVISOR
        mov [divisor], ebx      ; ASIGNO NUEVO VALOR AL DIVISOR
        jmp While               ; VUELVO AL WHILE DE ARRIBA

Iguales:
        call mostrarDivisor

finPrograma:              
        jmp salirDelPrograma
