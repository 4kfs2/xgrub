.include "init.inc"

.code32
pm_start:
	mov $sys_data_selector, %bx
	mov %bx, %ds
	mov %bx, %es
	mov %bx, %fs
	mov %bx, %gs
	mov %bx, %ss

	xor %eax, %eax
	mov $video_selector, %ax
	mov %ax, %es
	mov $1620, %edi
	lea (msgPmode), %esi
	call kernel_main
	jmp .

.global printf
printf:
	push %eax
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
	pop %eax
	ret

msgPmode:
	.ascii "Hello protected world!!"
	.byte 0
