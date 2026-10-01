;e) Haciendo uso del modo de direccionamiento base más índice más desplazamiento  
;reemplace la letra p de la cadena msg por la letra P.
;desplazamiento = numero real eemplo +5
%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;inicializas aux para recorrer
    mov ebx, msg ;inicializas o apuntas 
    mov esi, 10 ;aqui asignas el indice

    mov byte[msg+esi+5], 'P';asignaas el valor
    mov edx, msg ; se asigna el valor a la cadena principal
    call puts

    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa