%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 255
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    msg3 db ln,'minusculas: ', 0
    msg4 db ln,'mayusculas: ', 0
    
section .bss
    cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA ---
    mov edx, msg1
    call puts

    ; Capturar cadena
    mov edx, cadena
    mov ax, lencadena
    call captura

    ; Imprimir cadena original
    mov edx, msg2
    call puts

    mov edx, cadena
    call puts

    ;llama convertir minusculas ----------
    mov edx, cadena
    call minusculas

    mov edx, msg3
    call puts

    mov edx, cadena
    call puts

    ;llama convertir mayusculas ----------
    mov edx, cadena
    call mayusculas

    mov edx, msg4
    call puts

    mov edx, cadena
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

        cmp al, bskey ; backspace
        je .retroceder

        cmp ecx, ebx
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
        dec ecx   ;contador --

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

    ;para borrar
    borrar:
        push ax 
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop ax
        ret 



;funcion mayusculas----------------------------------------------------
    mayusculas:
        push edi
        mov edi, edx

    .recorrer_mayusculas:
        mov al,[edi] ;lee el caracter actual

        cmp al, 0
        je .fin_mayusculas

        cmp al, 'a' ;comprobar si esta antes de a
        jb .sigmayusculas; si es menor es mayusculas

        cmp al, 'z' ;comprobar si esta antes de a
        ja .sigmayusculas; si es menor es mayusculas

        ;si esta se resta 
        sub byte [edi], 32
    
    .sigmayusculas:
        inc edi ;sig caracter
        jmp .recorrer_mayusculas 

    .fin_mayusculas:
        pop edi ;valor original de EDI
        ret ;regresa inicio

;funcion minusculas-----------------------------------------------------
    minusculas:
        push edi            
        mov edi, edx       

    .recorrer_minusculas:
        mov al, [edi]     

        cmp al, 0          
        je .fin_minusculas   

        cmp al, 'A'         ;comprobar si esta antes de la letra A.
        jb .siguiente_minusculas ;si es mayor es mayuscula

        cmp al, 'Z'         ; Comprueba si esta despues de la letra Z.
        ja .siguiente_minusculas ; si es mayor no es mayuscula.

        add byte [edi], 32  ; suma 32 

    .siguiente_minusculas:
        inc edi            
        jmp .recorrer_minusculas 

    .fin_minusculas:
        pop edi          
        ret      