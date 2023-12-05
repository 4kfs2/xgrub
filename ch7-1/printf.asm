%include "init.inc"

global printf
printf:
	mov ebp, esp
	push es
	push eax
	mov ax, video_selector
	mov es, ax

printf_loop:
	or al, al
	jz printf_end
	mov al, byte [esi]
	mov byte [es:edi], al
	inc edi
	mov byte [es:edi], 0x06
	inc esi
	inc edi
	jmp printf_loop

printf_end:
	pop eax
	pop es
	ret
