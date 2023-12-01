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
	mov $idt_table_size, %ax
	mov $0, %edi

loop_idt:
	lea (idt_ignore), %esi
	mov $8, %cx
	rep movsb
	dec %ax
	jnz loop_idt

	mov $(8*0x20), %edi
	lea (idt_timer), %esi
	mov $8, %cx
	rep movsb

	mov $(8*0x21), %edi
	lea (idt_keyboard), %esi
	mov $8, %cx
	rep movsb

	lidt (idtr)

	mov $0xfc, %al
	out %al, $0x21
	sti
	call kernel_main
	jmp .

.global msg_isr_ignore, msg_isr_ignore2, msg_isr_32_timer, msg_isr_33_keyboard
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
	.ascii ".This is the timer interrupt"
	.byte 0
msg_isr_33_keyboard:
	.ascii ".This is the keyboard interrupt"
	.byte 0
