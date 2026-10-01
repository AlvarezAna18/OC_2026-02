%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena
    mov byte[msg+6],'Z'
    call puts

    ;a)
    mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena msg terminada en valor nulo (0)
	mov byte[msg],'Z'
    call puts

    ;b) Haciendo uso del modo de direccionamiento indirecto/registro reemplace la letra x de la cadena msg por la letra X.
     mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;inicializas aux para recorrer
    mov ebx, msg ;inicializas o apuntas 
    add ebx,23 ;recorras la cadena

    mov byte[ebx], 'X';asignaas el valor
    mov edx, msg ; se asigna el valor a la cadena principal
    call puts

    ;c) 
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;inicializas aux para recorrer
    mov ebx, msg ;inicializas o apuntas 
    mov byte[msg+26], '@';asignaas el valor
    mov edx, msg ; se asigna el valor a la cadena principal
    call puts

    ;d)

    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;inicializas aux para recorrer
    mov ebx, msg ;inicializas o apuntas 
    mov esi, 25 ;aqui asignas el indice

    mov byte[msg+esi], 'Z';asignaas el valor
    mov edx, msg ; se asigna el valor a la cadena principal
    call puts

    ;e
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;inicializas aux para recorrer
    mov ebx, msg ;inicializas o apuntas 
    mov esi, 10 ;aqui asignas el indice

    mov byte[msg+esi+5], 'P';asignaas el valor
    mov edx, msg ; se asigna el valor a la cadena principal
    call puts
    
    ;f
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;inicializas aux para recorrer
    mov ebx, msg +1 ;inicializas o apuntas se suma + por ser impar
    mov esi, 2 ;aqui asignas el indice

    mov byte[msg+esi*9], '%';asignaas el valor
    mov edx, msg ; se asigna el valor a la cadena principal
    call puts


    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa