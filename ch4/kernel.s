.include "init.inc"
.code32
pm_start:
	mov $sys_data_selector, %bx
	mov %bx, %ds
	mov %bx, %es
	mov %bx, %fs
	mov %bx, %gs
	mov %bx, %ss

	lea (pm_start), %esp

	xor %eax, %eax
	mov $video_selector, %ax
	mov %ax, %es
	mov $0, %edi
	lea (msgPmode), %esi
	call printf

	cld
	mov $idt_data_selector, %ax
	mov %ax, %es
	xor %eax, %eax
	xor %ecx, %ecx
	mov $256, %ax
	mov $0, %edi

loop_idt:
	lea (idt_ignore), %esi
	mov $8, %cx
	rep movsb
	dec %ax
	jnz loop_idt

	lidt (idtr)

	sti
	int $0x77
	jmp .

isr_ignore:
	push %gs
	push %fs
	push %es
	push %ds
	pushal
	pushfl

	mov $video_selector, %ax
	mov %ax, %es
	mov $1620, %edi
	lea (msg_isr_ignore), %esi
	call printf

	popfl
	popal
	pop %ds
	pop %es
	pop %fs
	pop %gs

	iret

idtr:
	.word 256 * 8 - 1
	.long 0

idt_ignore:
	.word isr_ignore
	.word idt_code_selector
	.byte 0
	.byte 0x8e
	.word 0x0001

idt_ignore2:
	.word isr_ignore
	.word idt_code_selector
	.byte 0
	.byte 0x8e
	.word 0x0001

msgPmode:
	.ascii "Hello protected world!!"
	.byte 0
msg_isr_ignore:
	.ascii "This is an ignorable interrupt"
	.byte 0
msg_isr_32_timer:
	.ascii "This is the timer interrupt"
	.byte 0
