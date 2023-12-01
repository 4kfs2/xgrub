.include "init.inc"

.code32
pm_start:
	mov $sys_data_selector, %bx
	mov %bx, %ds
	mov %bx, %es
	mov %bx, %fs
	mov %bx, %gs
	mov %bx, %ss

	xor %eax, %eax
	mov $video_selector, %ax
	mov %ax, %es
	mov $1620, %edi
	lea (msgPmode), %esi
	call kernel_main

	mov $u_data_selector, %ax
	mov %ax, %ds
	mov $0, %esi
	movb $0x34, %ds:(%esi)
	jmp .

msgPmode:
	.ascii "Hello protected world!!"
	.byte 0
