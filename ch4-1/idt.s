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

isr_32_timer:
	push %gs
	push %fs
	push %es
	push %ds
	pushal
	pushfl

	mov $0x20, %al
	out %al, $0x20

	mov $video_selector, %ax
	mov %ax, %es
	mov $(80*2*2), %edi
	lea (msg_isr_32_timer), %esi
	call printf
	incb (msg_isr_32_timer)

	popfl
	popal
	pop %ds
	pop %es
	pop %fs
	pop %gs

	iret

isr_33_keyboard:
	pushal
	push %gs
	push %fs
	push %es
	push %ds
	pushfl

	in $0x60, %al
	mov %al, %bl

	mov $0x20, %al
	out %al, $0x20

	mov $video_selector, %ax
	mov %ax, %es
	mov $(80*4*2), %edi
	lea (msg_isr_33_keyboard), %esi
	call printf

	cmp $5, %bl
	je key_4
	cmp $4, %bl
	je key_3
	cmp $3, %bl
	je key_2
	cmp $2, %bl
	je key_1
	jne out
key_4:
	mov $'4', %bl
	mov %bl, (msg_isr_33_keyboard)
	jmp out
key_3:
	mov $'3', %bl
	mov %bl, (msg_isr_33_keyboard)
	jmp out
key_2:
	mov $'2', %bl
	mov %bl, (msg_isr_33_keyboard)
	jmp out
key_1:
	mov $'1', %bl
	mov %bl, (msg_isr_33_keyboard)
out:
	popfl
	pop %ds
	pop %es
	pop %fs
	pop %gs
	popal

	iret

.global idtr, idt_ignore, idt_ignore2, idt_timer, idt_keyboard
idtr:
	.word idt_table_size * 8 - 1
	.long 0

idt_ignore:
	.word isr_ignore
	.word idt_code_selector
	.byte 0
	.byte 0x8e
	.word 0x0001

idt_timer:
	.word isr_32_timer
	.word idt_code_selector
	.byte 0
	.byte 0x8e
	.word 0x0001

idt_keyboard:
	.word isr_33_keyboard
	.word idt_code_selector
	.byte 0
	.byte 0x8e
	.word 0x0001
