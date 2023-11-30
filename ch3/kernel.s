.org 0
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
	lea %ds:(msgPmode), %esi
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
	.word 0x0000, 0x0000
	.word 0x0000, 0x0000

.set sys_code_selector, 0x08
	.word 0xffff
	.word 0x0000
	.byte 0x01
	.byte 0x9a
	.byte 0xcf
	.byte 0x00
.set sys_data_selector, 0x10
	.word 0xffff
	.word 0x0000
	.byte 0x01
	.byte 0x92
	.byte 0xcf
	.byte 0x00
.set video_selector, 0x18
	.word 0xffff
	.word 0x8000
	.byte 0x0b
	.byte 0x92
	.byte 0x40
	.byte 0x00
gdt_end:
