%include "init.inc"
[org 0x10000]
[bits 16]
start:
	cld
	mov ax, cs
	mov ds, ax
	xor ax, ax
	mov ss, ax

	xor ebx, ebx
	lea eax, [tss1]
	add eax, 0x10000
	mov [descriptor4 + 2], ax
	shr eax, 16
	mov [descriptor4 + 4], al
	mov [descriptor4 + 7], ah

	lea eax, [tss2]
	add eax, 0x10000
	mov [descriptor5 + 2], ax
	shr eax, 16
	mov [descriptor5 + 4], al
	mov [descriptor5 + 7], ah

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

	lea esi, [msgPmode]
	mov edi, 0
	call printf
	mov ax, tss_1_selector
	ltr ax
	lea eax, [process2]
	mov [tss2_eip], eax
	mov [tss2_esp], esp

	jmp tss_2_selector:0

	mov edi, 9*80*2
	lea esi, [msg_process1]
	call printf

	jmp $

process2:
	mov edi, 7*80*2
	lea esi, [msg_process2]
	call printf
	jmp tss_1_selector:0

%include "printf.asm"

gdtr:
	dw gdt_end - gdt -1
	dd gdt

gdt:
	dd 0, 0
	dd 0x0000ffff, 0x00cf9a00
	dd 0x0000ffff, 0x00cf9200
	dd 0x8000ffff, 0x0040920b
	dd 0x0000ffff, 0x00cffa02
	dd 0x0000ffff, 0x00cff203
	dd 0x0000ffff, 0x00cf9a00
	dd 0x0000ffff, 0x00cf9200

descriptor4:
	dw 104
	dw 0
	db 0
	db 0x89
	db 0
	db 0

descriptor5:
	dw 104
	dw 0
	db 0
	db 0x89
	db 0
	db 0
gdt_end:

tss1:
	dw 0, 0
	dd 0
	dw 0, 0
	dd 0
	dw 0, 0
	dd 0
	dw 0, 0
	dd 0, 0, 0
	dd 0, 0, 0, 0
	dd 0, 0, 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0
	dw 0, 0

tss2:
	dw 0, 0
	dd 0
	dw 0, 0
	dd 0
	dw 0, 0
	dd 0
	dw 0, 0
	dd 0

tss2_eip:
	dd 0, 0
	dd 0, 0, 0, 0

tss2_esp:
	dd 0, 0, 0, 0
	dw sys_data_selector, 0
	dw sys_code_selector, 0
	dw sys_data_selector, 0
	dw sys_data_selector, 0
	dw sys_data_selector, 0
	dw sys_data_selector, 0
	dw 0, 0
	dw 0, 0

msgPmode db "Hello protected world!!", 0
msg_process1 db "This is System Process1", 0
msg_process2 db "This is System Process2", 0

times 1024-($-$$) db 0
