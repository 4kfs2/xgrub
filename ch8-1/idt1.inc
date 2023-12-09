isr_ignore:
	push gs
	push fs
	push es
	push ds
	pushad

	mov ax, sys_data_selector
	mov DS, ax
	mov ES, ax
	mov FS, ax
	mov GS, ax

	mov al, 0x20
	out 0x20, al
	
	mov edi, (80*2*0)
	lea esi, [msg_isr_ignore]
	call printf
	inc byte [msg_isr_ignore]

	jmp ret_from_int

isr_32_timer:
	push gs
	push fs
	push es
	push ds
	pushad

	mov ax, sys_data_selector
	mov DS, ax
	mov ES, ax
	mov FS, ax
	mov GS, ax

	mov al, 0x20
	out 0x20, al
	
	mov edi, 80*2*0
	lea esi, [msg_isr_32_timer]
	call printf
	inc byte [msg_isr_32_timer]

	jmp ret_from_int

isr_33_keyboard:
	push gs
	push fs
	push es
	push ds
	pushad

	mov ax, sys_data_selector
	mov DS, ax
	mov ES, ax
	mov FS, ax
	mov GS, ax

	in al, 0x60

	mov al, 0x20
	out 0x20, al
	
	mov edi, (80*2*0)+(2*35)
	lea esi, [msg_isr_33_keyboard]
	call printf
	inc byte [msg_isr_33_keyboard]

	jmp ret_from_int

isr_128_soft_int:
	push gs
	push fs
	push es
	push ds
	pushad

	push eax
	mov ax, sys_data_selector
	mov DS, ax
	mov ES, ax
	mov FS, ax
	mov GS, ax
	pop eax

	mov edi, eax
	lea esi, [ebx]
	call printf

	jmp ret_from_int

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $

isr_01:
	mov edi, (80*12*2)
	lea esi, [msg_isr_01_debug]
	call printf
	jmp $

isr_02:
	mov edi, (80*12*2)
	lea esi, [msg_isr_02_nmi]
	call printf
	jmp $

isr_03:
	mov edi, (80*12*2)
	lea esi, [msg_isr_03]
	call printf
	jmp $

isr_04:
	mov edi, (80*12*2)
	lea esi, [msg_isr_04_into]
	call printf
	jmp $

isr_05:
	mov edi, (80*12*2)
	lea esi, [msg_isr_05_bound]
	call printf
	jmp $

isr_06:
	mov edi, (80*12*2)
	lea esi, [msg_isr_06_opcode]
	call printf
	jmp $

isr_07:
	mov edi, (80*12*2)
	lea esi, [msg_isr_07_coprocess]
	call printf
	jmp $

isr_08:
	mov edi, (80*12*2)
	lea esi, [msg_isr_08_double_fault]
	call printf
	jmp $

isr_09:
	mov edi, (80*12*2)
	lea esi, [msg_isr_09_coprocess_segment]
	call printf
	jmp $

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $

isr_00:
	mov edi, (80*12*2)
	lea esi, [msg_isr_00_zero_divide]
	call printf
	jmp $



ret_from_int:
	xor eax, eax
	mov eax, [esp+52]
	and eax, 0x00000003
	xor ebx, ebx
	mov bx, cs
	and ebx, 0x00000003
	cmp eax, ebx
	ja scheduler

	popad
	pop ds
	pop es
	pop fs
	pop gs

	iret

msg_isr_ignore db "This is an ignoreable interrupt", 0
msg_isr_32_timer db ".This is the timer interrupt", 0	
msg_isr_33_keyboard db ".This is the keyboard interrupt", 0
msg_isr_128_soft_int db ".This is the soft int interrupt", 0

idt_ignore:
	dw isr_ignore
	dw 0x08
	db 0
	db 0x8e
	dw 0x0001

idt_timer:
	dw isr_32_timer
	dw 0x08
	db 0
	db 0x8e
	dw 0x0001

idt_keyboard:
	dw isr_33_keyboard
	dw 0x08
	db 0
	db 0x8e
	dw 0x0001

idt_soft_int:
	dw isr_128_soft_int
	dw 0x08
	db 0
	db 0xef
	dw 0x0001
