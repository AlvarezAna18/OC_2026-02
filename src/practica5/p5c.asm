;c) Haciendo uso del modo de direccionamiento base más desplazamiento 
;reemplace el número 0 de la cadena msg por el símbolo @.

%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;inicializas aux para recorrer
    mov ebx, msg ;inicializas o apuntas 
    mov byte[msg+26], '@';asignaas el valor
    mov edx, msg ; se asigna el valor a la cadena principal
    call puts

    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa
