%include "init.inc"

global printf
printf:
	push eax
	push es
	mov ax, video_selector
	mov es, ax

printf_loop:
	or al, al
	jz printf_end
	mov al, [esi]
	mov byte [es:edi], al
	inc edi
	mov byte [es:edi], 0x06
	inc esi
	inc edi
	jmp printf_loop

printf_end:
	pop es
	pop eax
	ret
