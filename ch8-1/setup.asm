%include "init.inc"

PAGE_DIR		equ 0x100000
PAGE_TAB_KERNEL	equ 0x101000
PAGE_TAB_USER	equ 0x102000
PAGE_TAB_LOW	equ 0x103000

[org 0x900000]
[bits 16]

start:
	cld
	mov ax, cs
	mov ds, ax
	xor ax, ax
	mov ss, ax

	xor eax, eax
	lea eax, [tss]

	add eax, 0x90000
	mov [descriptor4 + 2], ax
	shr eax, 16
	mov [descriptor4 + 4], al
	mov [descriptor4 + 7], ah

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

	mov esi, 0x80000
	mov edi, 0x200000
	mov cx, 512*7

gdtr:
	dw gdt_end-gdt-1
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

gdt_end: