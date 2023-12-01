.include "init.inc"
.code16
start:
	mov %cs, %ax
	mov %ax, %ds
	xor %ax, %ax
	mov %ax, %ss

	cli
	lgdt (gdtr)
	mov %cr0, %eax
	or $0x00000001, %eax
	mov %eax, %cr0
	jmp . + 2
	nop
	nop

	jmpw $sys_code_selector, $pm_start

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

gdtr:
	.word gdt_end - gdt - 1
	.long gdt + 0x10000

gdt:
	.long 0
	.long 0

	.long 0x0000ffff
	.long 0x00cf9a01

	.long 0x0000ffff
	.long 0x00cf9201

	.long 0x8000ffff
	.long 0x0040920b
gdt_end:

