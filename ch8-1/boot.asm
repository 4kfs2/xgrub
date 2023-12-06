%include "init.inc"

[org 0]
	jmp 0x7c0:start

%include "a20.inc"

start:
	mov ax, cs
	mov ds, ax
	mov es, ax

	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov ax, word [msgBack]
	mov cx, 0x7ff

paint:
	mov word [es:di], ax
	add di, 2
	dec cx
	jnz paint

read_setup:
	mov ax, 0x9000
	mov es, ax
	mov bx, 0

	mov ah, 2
	mov al, 2
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_setup

read_kerenel:
	mov ax, 0x8000
	mov es, ax
	mov bx, 0

	mov ah, 2
	mov al, 7
	mov ch, 0
	mov cl, 4
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_kerenel

read_user1:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 11
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user1

read_user2:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x200

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 12
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user2

read_user3:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x400

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 13
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user3

read_user4:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x600

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 14
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user4

read_user5:
	mov ax, 0x7000
	mov es, ax
	mov bx, 0x800

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 15
	mov dh, 0
	mov dl, 0
	int 0x13

	jc read_user5

	mov dx, 0x3F2
	xor al, al
	out dx, al

	cli

	ca

	push ds
	mov ax, 0
	mov ds, ax
	mov si, 1
	mov word [ds:si], 0

	mov ax, 0xffff
	mov ds, ax
	mov si, 0x11
	mov word [ds:si], 0x1234

	mov ax, 0
	mov ds, ax
	mov si, 1
	mov bx, word [ds:si]
	pop ds
	cmp bx, 0x1234
	je noA20

yesA20:
	mov ax, 0xb800
	mov es, ax
	mov di, 0
	lea si, [msgA20on]

yes_loop:
	mov al, byte [si]
	cmp al, 0
	je stop
	mov byte [es:di], al
	inc si
	inc di
	mov byte [es:di], 0x06
	inc di
	jmp yes_loop

noA20:
	mov ax, 0xb800
	mov es, ax
	mov di, 0
	lea si, [msgA20off]

no_loop:
	mov al, byte [si]
	cmp al, 0
	je stop
	mov byte [es:di], al
	inc si
	inc di
	mov byte [es:di], 0x06
	inc di
	jmp no_loop

stop:
	jmp $

msgBack db ' ', 0x07
msgA20on db "A20 on ", 0
msgA20off db "A20 off ",0

times 64 db 0

boot_stack:
	times 510-($-$$) db 0
	dw 0xaa55


