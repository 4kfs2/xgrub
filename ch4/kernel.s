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
	lea (idt_ignore2), %esi
	mov $8, %cx
	rep movsb
	dec %ax
	dec %ax
	jnz loop_idt

	lidt (idtr)

	sti
	int $0x77
	int $0x78
	jmp .

.global msg_isr_ignore, msg_isr_ignore2
msgPmode:
	.ascii "Hello protected world!!"
	.byte 0
msg_isr_ignore:
	.ascii "This is an ignorable interrupt"
	.byte 0
msg_isr_ignore2:
	.ascii "This is an ignorable interrupt2!"
	.byte 0
msg_isr_32_timer:
	.ascii "This is the timer interrupt"
	.byte 0
