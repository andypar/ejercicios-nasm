; Se ingresa un año. La computadora indica si es, o no, bisiesto.
;
; En Windows:
; 1) nasm -f win32 final_3.asm --PREFIX _
; 2) gcc final_3.obj -o final_3.exe
; 3) final_3


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

anioStr:
        db    "Ingrese Anio: ", 0        

bisiestoStr:
        db    " es Bisiesto ", 0        

noBisiestoStr:
        db    " no es Bisiesto ", 0     




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

modulo:                         ; calcs eax mod ebx, returns eax
        mov edx, 0              ; clear higher 32-bits as edx:eax / ebx is calced
        idiv ebx                ; divide the contents of EDX:EAX by the contents of EBX. Place the quotient in EAX and the remainder in EDX.
        ret


salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit





_start:
main:    
        mov ebx, 0                      ; PUNTO DE INICIO DEL PROGRAMA

copiaAcadena:
        mov al, [ebx+anioStr]           ; PIDO  QUE SE INGRESE ANIO
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena
        call mostrarCadena
        call leerNumero                 ; LEO EL ANIO INGRESADO


divisible1:
        mov ebx, 0

        mov eax, [numero]               ; ME FIJO SI ES DIVISIBLE POR 400
        mov ebx, 400 
        push eax                        ; PRESERVO EL VALOR DE EAX DE LOS SYSTEM CALLS
        call mostrarNumero
        pop eax                         ; RESTAURO EL VALOR DE EAX

        call modulo
        cmp edx, 0              
        je EsBisiesto                   ; SI LO ES, ES BISIESTO


divisible2:		
        mov eax, [numero]               ; ME FIJO SI ES DIVISIBLE POR 4
        mov ebx, 4 
        call modulo
        cmp edx, 0
        jne NoEsBisiesto                ; SI NO LO ES, NO ES BISIESTO

divisible3:
        mov eax, [numero]               ; ME FIJO SI ES DIVISIBLE POR 100
        mov ebx, 100 
        call modulo
        cmp edx, 0
        je NoEsBisiesto                 ; SI LO ES, NO ES BISIESTO


EsBisiesto:
        mov ebx, 0

copiaAcadena2:                          ; IMPRIMO "SI ES BISIESTO"
        mov al, [ebx+bisiestoStr]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena2
        call mostrarCadena
        call finPrograma


NoEsBisiesto:
        mov ebx, 0

copiaAcadena3:                          ; IMPRIMO "NO ES BISIESTO"
        mov al, [ebx+noBisiestoStr]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena3
        call mostrarCadena
        call finPrograma


finPrograma:              
        jmp salirDelPrograma
