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

isr_ignore2:
	push %gs
	push %fs
	push %es
	push %ds
	pushal
	pushfl

	mov $video_selector, %ax
	mov %ax, %es
	mov $2620, %edi
	lea (msg_isr_ignore), %esi
	call printf

	popfl
	popal
	pop %ds
	pop %es
	pop %fs
	pop %gs

	iret

