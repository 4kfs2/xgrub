.include "init.inc"
.global isr_ignore, isr_ignore2, idt_table_size
.equ idt_table_size, 256
isr_ignore:
	push %gs
	push %fs
	push %es
	push %ds
	pushal
	pushfl

	mov $video_selector, %ax
	mov %ax, %es
	mov $(80*7*2), %edi
	lea (msg_isr_ignore), %esi
	call printf

	popfl
	popal
	pop %ds
	pop %es
	pop %fs
	pop %gs

	iret

isr_ignore2:
	push %gs
	push %fs
	push %es
	push %ds
	pushal
	pushfl

	mov $video_selector, %ax
	mov %ax, %es
	mov $(80*8*2), %edi
	lea (msg_isr_ignore2), %esi
	call printf

	popfl
	popal
	pop %ds
	pop %es
	pop %fs
	pop %gs

	iret

.global idtr, idt_ignore, idt_ignore2
idtr:
	.word idt_table_size * 8 - 1
	.long 0

idt_ignore:
	.word isr_ignore
	.word idt_code_selector
	.byte 0
	.byte 0x8e
	.word 0x0001

idt_ignore2:
	.word isr_ignore2
	.word idt_code_selector
	.byte 0
	.byte 0x8e
	.word 0x0001
