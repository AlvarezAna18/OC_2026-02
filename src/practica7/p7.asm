%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

;mensajes y constantes
section .data
    backspace equ 0x7F
    lencadena equ 64 ; LIMITE DE 64
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura numero: ', 0
    msg2 db ln,'Cadena orginal: ', 0
    msg3 db ln,'Entero a cadena: ', 0

;reservar memoria
section .bss
    cadena resb lencadena
    salida resb lencadena
    numero resd 1

section .text
    global _start ; referencia para inicio de programa
    
_start:   

    ; Capturar cadena de numeros
    mov edx, msg1
    call puts

    mov edx, cadena 
    mov ax, lencadena
    call captura

     ; ATOI: convertir cadena a entero
    mov edx, cadena
    call atoi
    mov [numero], eax

    ; ITOA: convertir entero a cadena
    mov eax, [numero]
    mov edx, salida
    mov ecx, lencadena
    call itoa

    ; Mostrar cadena original
    mov edx, msg2
    call puts

    mov edx, cadena
    call puts

    ; Mostrar conversion
    mov edx, msg3
    call puts

    mov edx, salida
    call puts

    jmp .fin_programa  ;fin programa
    
    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa


  ;captura--------------------------------- 
    captura:
        push ebx
        push ecx
        push edi

        mov edi, edx
        movzx ebx, ax
        dec ebx               
        xor ecx, ecx

        .leer:
        call getch ;lee tecla

        cmp al, ln ;compara caracter para salto de linea
        je .fin_captura

        cmp al, backspace ; backspace
        je .retroceder

        cmp ecx, ebx ; se evalua si usa espavcio de msg
        jae .leer

        mov [edi], al ;guardar en memoria
        inc edi ;avanza a sig posicion
        inc ecx ; inc contador de caracter

        call putchar ;muestra caracter capturadp
        jmp .leer

        .retroceder:
        cmp ecx, 0
        je .leer

        dec edi ;retrocede pos en la memoria.
        dec ecx ;contador --

        call borrar
        jmp .leer

    ;terminar captura funcion
    .fin_captura:

        mov byte [edi], 0   ;escribe nulo al final.

        mov edx, nline   
        call puts ; baja siguiente linea

        pop edi 
        pop ecx          
        pop ebx   
        ret ;regresa al programa principal

    ;para borrar-----------------------------------------
    borrar:
        push eax 

        mov al,0x8
        call putchar    

        mov al,' '
        call putchar

        mov al,0x8
        call putchar   

        pop eax
        ret 

;atoi----------------------------------------
;edx direccion de cadena
;eax entero con sig

atoi:
    push ebx
    push ecx
    push esi 

    mov esi, edx
    xor eax, eax;registro en 0
    mov ebx,1 

;espacios y tabulaciones
.espacios:
    mov cl, [esi]

    cmp cl, ' '
    je .avanzar

    cmp cl, 9
    je .avanzar

    jmp .signo

;avanzar y llamar espacios
.avanzar:
    inc esi
    jmp .espacios

;revisar el signo
.signo:
    cmp byte[esi], '-' ;verificar si es negativo
    jne .positivo

    mov ebx, -1
    inc esi
    jmp .digitos


.positivo:
    cmp byte [esi],'+'
    jne .digitos

    inc esi

;convertir los digitos
.digitos:
    movzx ecx, byte[esi] ;copia el byte y deja el resto del registro sin modificar

    cmp ecx, '0'
    jb .fin_atoi

    cmp ecx,'9'
    ja .fin_atoi

    sub ecx, '0'

    imul eax, eax, 10 ;mul con signo eax=eax*10
    add eax, ecx
    
    inc esi
    jmp .digitos

.fin_atoi:
    cmp ebx, -1
    jne .return
    neg eax 

.return:
    pop esi
    pop ecx
    pop ebx
    ret

;ITOA----------------------------------------

itoa:

    push ebx
    push ecx  
    push edx 
    push esi 
    push edi
    push ebp

    mov esi, edx
    mov ebp, edx
    xor ecx, ecx

    ;ver si hay signo negativo
    test eax, eax  ;and entero con signo
    jns .positivo_itoa

    mov ecx, 1 
    neg eax

.positivo_itoa:
    mov edi, esi
    mov ebx, 10 

    ;si es cero 
    cmp eax, 0
    jne .extraer

    mov byte[edi], '0'
    inc edi
    jmp .signo_itoa

    ;extraer por divisiones
.extraer:
    xor edx, edx
    div ebx

    add dl,'0'
    mov[edi],dl
    inc edi

    cmp eax, 0
    jne .extraer

    ;poner signo si es negativo
.signo_itoa:
    cmp ecx, 1 
    jne .terminar_itoa

    mov byte[edi], '-'
    inc edi

.terminar_itoa:
    mov byte[edi], 0
    ;invertir caracter
    dec edi

.invertir:
    cmp esi, edi
    jae .fin_itoa

    mov al, [esi]
    mov ah, [edi]

    ;intercambia bytes
    mov[esi], ah
    mov[edi], al

    inc esi 
    dec edi 
    jmp .invertir

.fin_itoa:
    mov eax, ebp
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret