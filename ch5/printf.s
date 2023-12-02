.include "init.inc"
.global printf
printf:
	push %eax
	push %es
	mov $video_selector, %ax
	mov %ax, %es

printf_loop:
	or %al, %al
	jz printf_end
	movb (%esi), %al
	movb %al, %es:(%edi)
	inc %edi
	movb $0x06, %es:(%edi)
	inc %esi
	inc %edi
	jmp printf_loop
printf_end:
	pop %es
	pop %eax
	ret
