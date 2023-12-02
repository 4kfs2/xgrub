.include "init.inc"

.org 0
.code16

	jmp $0x7c0, $start

start:
	mov %cs, %ax
	mov %ax, %ds
	mov %ax, %es

reset:
	mov $0, %ax // 플로피디스크 초기화
	mov $0, %dl
	int $0x13
	jc reset

	mov $0xb800, %ax
	mov %ax, %es
	mov $0, %di
	movw (msgBack), %ax
	mov $0x7ff, %cx

paint:
	movw %ax, %es:(%di)
	add $2, %di
	dec %cx
	jnz paint

read:
	mov $0x1000, %ax
	mov %ax, %es
	mov $0, %bx

	mov $2, %ah
	mov $2, %al
	mov $0, %ch
	mov $2, %cl
	mov $0, %dh
	mov $0, %dl
	int $0x13

	jc read

	mov $0x3f2, %dx
	xor %al, %al
	outb %al, %dx

	jmpl $0x1000, $0x0000	

msgBack:
	.byte '.', 0x67

.org 510
.word 0xaa55
