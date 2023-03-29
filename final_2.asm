; Se ingresa una cadena. La computadora muestra las subcadenas formadas por las posiciones pares e impares de la cadena. Ej: FAISANSACRO : ASNAR FIASCO
;
; En Windows:
; 1) nasm -f win32 final_2.asm --PREFIX _
; 2) gcc final_2.obj -o final_2.exe
; 3) final_2


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
        db    "Ingrese una cadena: ", 0  




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

mostrarCadenaInicio:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadenaInicio
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
main:                                   ; PUNTO DE INICIO DEL PROGRAMA
        mov ebx, 0   

copiaAcadena:
        mov al, [ebx+cadenaStr]         ; PIDO QUE SE INGRESE UNA CADENA
        mov [ebx+cadenaInicio], al
        inc ebx
        cmp al, 0
        jne copiaAcadena
        call mostrarCadenaInicio

        call leerCadena                 ; LLAMO A LEER CADENA
        mov edi,1                       

seguir:                                 ; PARA MOSTRAR POSICIONES PARES ARRANCO CON EDI EN 1
        mov al, [edi + cadena]
        cmp al, 0
        je seguir2
            
        mov [caracter], al              ; ARRANCO MOSTRANDO POSICIONES PARES HASTA LLEGAR A FIN DE LINEA
        call mostrarCaracter
        add edi, 2                      
        jmp seguir 

seguir2:
        call mostrarSaltoDeLinea
        mov edi, 0                      ; PARA MOSTRAR POSICIONES IMPARES ARRANCO CON EDI EN 0
        mov al, 0

seguir3:
        mov al,[edi + cadena]           ; IMPRIMO HASTA LLEGAR FIN DE LINEA
        cmp al, 0
        je finPrograma
            
        mov [caracter], al
        call mostrarCaracter
        add edi, 2                      
        jmp seguir3

finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma
