%include "init.inc"

[org 0xC0000000]
[bits 32]

	mov esp, 0xC0000FFF

%include "idt0.inc"

	lidt [idtr]

	mov al, 0xFC
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
	mov eax, [TSS_ESP0_WHERE]
	mov [eax], esp

	lea esp, [ebx]

	popad
	pop ds
	pop es
	pop fs
	pop gs

	iretd

current_task dd 0
num_task dd 20
task_list: times 5 dd 0

%include "printf.inc"
%include "user_task_structure.inc"
%include "idt1.inc"

idtr:
	dw 256*8 - 1 
	dd IDT_BASE

%include "idt2.inc"

times 512*7-($-$$) db 0