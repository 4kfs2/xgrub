%include "init.inc"

[org 0x10000]
[bits 16]

start:
	cld
	mov ax, cs
	mov ds, ax
	xor ax, ax
	mov ss, ax

	xor eax, eax
	lea eax, [tss]
	add eax, 0x10000
	mov [descriptor6 + 2], ax
	shr eax, 16
	mov [descriptor6 + 4], al
	mov [descriptor6 + 7], ah

	xor eax, eax
	lea eax, [printf]
	add eax, 0x10000
	mov [descriptor7], ax
	shr eax, 16
	mov [descriptor7 + 6], al
	mov [descriptor7 + 7], ah

	cli
	lgdt [gdtr]

	mov eax, cr0
	or eax, 0x00000001
	mov cr0, eax

	jmp $+2
	nop
	nop
	jmp dword sys_code_selector:pm_start

[bits 32]
	times 80 dd 0

pm_start:
	mov bx, sys_data_selector
	mov ds, bx
	mov es, bx
	mov fs, bx
	mov gs, bx
	mov ss, bx

	lea esp, [pm_start]

	cld
	mov ax, sys_data_selector
	mov es, ax
	xor eax, eax
	xor ecx, ecx
	mov ax, 256
	mov edi, 0

loop_idt:
	lea esi, [idt_ignore]
	mov cx, 8
	rep movsb
	dec ax
	jnz loop_idt

	mov edi, 8*0x20
	lea esi, [idt_timer]
	mov cx, 8
	rep movsb

	mov edi, 8*0x21
	lea esi, [idt_keyboard]
	mov cx, 8
	rep movsb

	mov edi, 8*0x80
	lea esi, [idt_soft_int]
	mov cx, 8
	rep movsb

	lidt [idtr]

	mov al, 0xfc
	out 0x21, al
	sti

	mov ax, tss_selector
	ltr ax

	mov eax, [current_task]
	add eax, task_list
	lea edx, [user_1_regs]
	mov [eax], edx
	add eax, 4
	lea edx, [user_2_regs]
	mov [eax], edx
	add eax, 4
	lea edx, [user_3_regs]
	mov [eax], edx
	add eax, 4
	lea edx, [user_4_regs]
	mov [eax], edx
	add eax, 4
	lea edx, [user_5_regs]
	mov [eax], edx

	mov eax, [current_task]
	add eax, task_list
	mov ebx, [eax]
	jmp sched

scheduler:
	lea esi, [esp]

	xor eax, eax
	mov eax, [current_task]
	add eax, task_list

	mov edi, [eax]

	mov ecx, 17
	rep movsd
	add esp, 68

	add dword [current_task], 4
	mov eax, [num_task]
	mov ebx, [current_task]
	cmp eax, ebx
	jne yet
	mov byte [current_task], 0

yet:
	xor eax, eax
	mov eax, [current_task]
	add eax, task_list
	mov ebx, [eax]

sched:
	mov [tss_esp0], esp

	lea esp, [ebx]

	popad
	pop ds
	pop es
	pop fs
	pop gs

	iret

current_task dd 0
num_task dd 20
task_list: times 5 dd 0

%include "printf.asm"
%include "user.asm"

gdtr:
	dw gdt_end-gdt-1
	dd gdt

gdt:
	dd 0, 0
	dd 0x0000ffff, 0x00cf9a00
	dd 0x0000ffff, 0x00cf9200
	dd 0x8000ffff, 0x0040920b
	dd 0x0000ffff, 0x00fcfa00
	dd 0x0000ffff, 0x00fcf200

descriptor6:
	dw 104
	dw 0
	db 0
	db 0x89
	db 0
	db 0

descriptor7:
	dw 0
	dw sys_code_selector
	db 0x02
	db 0xec
	db 0
	db 0
gdt_end:

tss:
	dw 0, 0
tss_esp0:
	dd 0
	dw sys_data_selector, 0
	dd 0
	dw 0, 0
	dd 0
	dw 0, 0
	dd 0

tss_eip:
	dd 0, 0
	dd 0, 0, 0, 0

tss_esp:
	dd 0, 0, 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0

%include "user_area.asm"
%include "isr.asm"

times 4608-($-$$) db 0
