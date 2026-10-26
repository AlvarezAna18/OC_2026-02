%include "../../lib/pc_io.inc"

section .data
    backspace equ 0x7F
    lencadena equ 64
    ln equ 0x0A
    nline db ln,0
    msg1 db "Entrada: ",0
    msg2 db "Salida: ",0

section .bss
    cadena resb lencadena
    salida resb lencadena
    numero resd 1

section .text
    global _start

_start:
    mov edx,msg1
    call puts

    mov edx,cadena
    mov ax,lencadena
    call captura

    ; ATOI: cadena a entero
    mov edx,cadena
    call atoi
    mov [numero],eax

    ; ITOA: entero a cadena
    mov eax,[numero]
    mov edx,salida
    mov ecx,lencadena
    call itoa

    mov edx,msg2
    call puts
    mov edx,salida
    call puts

    mov edx,nline
    call puts

    mov eax,1
    xor ebx,ebx
    int 0x80

;capturar EDX = buffer, AX = capacidad
captura:
    push ebx
    push edi
    push ecx

    mov edi,edx
    movzx ebx,ax
    dec ebx
    xor ecx,ecx

.leer:
    call getch
    cmp al,ln
    je .fin

    cmp al,backspace
    je .borrar

    cmp ecx,ebx
    jae .leer

    mov [edi],al
    inc edi
    inc ecx
    call putchar
    jmp .leer

.borrar:
    cmp ecx,0
    je .leer
    dec edi
    dec ecx
    call borrar_caracter
    jmp .leer

.fin:
    mov byte [edi],0
    mov edx,nline
    call puts

    pop ecx
    pop edi
    pop ebx
    ret

borrar_caracter:
    push eax
    mov al,8
    call putchar
    mov al,' '
    call putchar
    mov al,8
    call putchar
    pop eax
    ret

;ATOI edx= cadena eax= entero con signo
atoi:
    push ebx
    push ecx
    push esi

    mov esi,edx
    xor eax,eax
    mov ebx,1

.espacios:
    mov cl,[esi]
    cmp cl,' '
    je .avanzar
    cmp cl,9
    je .avanzar
    jmp .signo

.avanzar:
    inc esi
    jmp .espacios

.signo:
    cmp byte [esi],'-'
    jne .mas
    mov ebx,-1
    inc esi
    jmp .digitos

.mas:
    cmp byte [esi],'+'
    jne .digitos
    inc esi

.digitos:
    movzx ecx,byte [esi]
    cmp ecx,'0'
    jb .fin_atoi
    cmp ecx,'9'
    ja .fin_atoi

    sub ecx,'0'
    imul eax,eax,10
    add eax,ecx
    inc esi
    jmp .digitos

.fin_atoi:
    cmp ebx,-1
    jne .salir
    neg eax

.salir:
    pop esi
    pop ecx
    pop ebx
    ret

itoa:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    mov esi,edx       ; direccion inicial
    mov edi,edx       ; posicion de escritura
    mov ebp,ecx       ; longitud del buffer
    xor ecx,ecx       ; signo: 0 positivo, 1 negativo

    cmp ebp,1
    jbe .vacio

    test eax,eax
    jns .positivo

    mov ecx,1
    neg eax

.positivo:
    mov ebx,10

    test eax,eax
    jnz .extraer

    mov byte [edi],'0'
    inc edi
    jmp .signo

.extraer:
    ; Comprobar espacio para digito y terminador
    mov edx,edi
    sub edx,esi
    inc edx
    cmp edx,ebp
    jae .terminar

    xor edx,edx
    div ebx
    add dl,'0'
    mov [edi],dl
    inc edi

    test eax,eax
    jnz .extraer

.signo:
    cmp ecx,1
    jne .terminar

    mov edx,edi
    sub edx,esi
    inc edx
    cmp edx,ebp
    jae .terminar

    mov byte [edi],'-'
    inc edi

.terminar:
    mov byte [edi],0
    dec edi

.invertir:
    cmp esi,edi
    jae .retornar

    mov al,[esi]
    mov ah,[edi]
    mov [esi],ah
    mov [edi],al

    inc esi
    dec edi
    jmp .invertir

.vacio:
    mov byte [esi],0

.retornar:
    mov eax,[esp+12]  ; recuperar direccion original de EDX

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret