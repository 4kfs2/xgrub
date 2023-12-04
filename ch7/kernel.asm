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
	mov [descriptor4 + 2], ax
	shr eax, 16
	mov [descriptor4 + 4], al
	mov [descriptor4 + 7], ah

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
pm_start:
	mov bx, sys_data_selector
	mov ds, bx
	mov es, bx
	mov fs, bx
	mov gs, bx
	mov ss, bx

	lea esp, [pm_start]

	mov ax, tss_selector
	ltr ax

	mov [tss_esp0], esp
	lea eax, [pm_start - 256]
	mov [tss_esp], eax

	mov ax, u_data_selector
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	lea esp, [pm_start - 256]

	push dword u_data_selector
	push esp
	push dword 0x200
	push dword u_code_selector
	lea eax, [user_process]
	push eax
	iretd

printf:
	mov ebp, esp
	push es
	push eax
	mov ax, video_selector
	mov es, ax
	mov esi, [ebp + 8]
	mov edi, [ebp + 12]

printf_loop:
	or al, al
	jz printf_end
	mov al, byte [esi]
	mov byte [es:edi], al
	inc edi
	mov byte [es:edi], 0x06
	inc esi
	inc edi
	jmp printf_loop

printf_end:
	pop eax
	pop es
	ret

user_process:
	mov edi, 7*80*2
	push edi
	lea eax, [msg_user_parameter1]
	push eax
	call a20_selector:0
	jmp $

msg_user_parameter1 db "This is user Process", 0

gdtr:
	dw gdt_end - gdt -1
	dd gdt

gdt:
	dd 0, 0
	dd 0x0000ffff, 0x00cf9a00
	dd 0x0000ffff, 0x00cf9200
	dd 0x8000ffff, 0x0040920b

descriptor4:
	dw 104
	dw 0
	db 0
	db 0x89
	db 0
	db 0

	dd 0x0000ffff, 0x00fcfa00
	dd 0x0000ffff, 0x00fcf200

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
	dw u_data_selector, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0


times 1024-($-$$) db 0
