.org 0
.code16

start:
	mov %cs, %ax
	mov %ax, %ds
	xor %ax, %ax
	mov %ax, %ss

	lea (msgKernel), %esi
	mov $0xb800, %ax
	mov %ax, %es
	mov $0x14a, %edi
	call printf

	jmp .

printf:
	push %eax

printf_loop:
	movb (%esi), %al
	movb %al, %es:(%edi)
	or %al, %al
	jz printf_end
	inc %edi
	movb $0x06, %es:(%edi)
	inc %esi
	inc %edi
	jmp printf_loop

printf_end:
	pop %eax
	ret

msgKernel:
	.ascii "Hello kernel world!!"
	.byte 0
