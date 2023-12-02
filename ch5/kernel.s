.include "init.inc"

.code16
start:
	cld
	mov %cs, %ax
	mov %ax, %ds
	xor %ax, %ax
	mov %ax, %ss

	xor %ebx, %ebx
	lea (tss1), %eax
	add $0x10000, %eax
	movw %ax, (descriptor4 + 2)
	shr $16, %eax
	movb %al, (descriptor4 + 4)
	movb %ah, (descriptor4 + 7)

	lea (tss2), %eax
	add $0x10000, %eax
	movw %ax, (descriptor5 + 2)
	shr $16, %eax
	movb %al, (descriptor5 + 4)
	movb %ah, (descriptor5 + 7)

	cli
	
	lgdt (gdtr)

	mov %cr0, %eax
	or $0x00000001, %eax
	mov %eax, %cr0

	jmp . + 2
	nop
	nop
	jmpl $sys_code_selector, $pm_start

.code32
pm_start:
	mov $sys_data_selector, %bx
	mov %bx, %ds
	mov %bx, %es
	mov %bx, %fs
	mov %bx, %gs
	mov %bx, %ss

	lea (pm_start), %esp

	lea (msgPmode), %esi
	mov $0, %edi
	call printf

	mov $tss_1_selector, %ax
	ltr %ax
	lea (process2), %eax
	mov %eax, (tss2_eip)
	mov %esp, (tss2_esp)

	jmp $tss_2_selector, $0

	mov $(9*80*2), %edi
	lea (msg_process1), %esi
	call printf
	jmp .

process2:
	mov $(7*80*2), %edi
	lea (msg_process2), %esi
	call printf
	jmp $tss_1_selector, $0

gdtr:
	.word gdt_end - gdt - 1
	.long gdt + 0x10000

gdt:
	.long 0, 0
	.long 0x0000ffff, 0x00cf9a01
	.long 0x0000ffff, 0x00cf9201
	.long 0x8000ffff, 0x0040920b
	.long 0x0000ffff, 0x00cffa02
	.long 0x0000ffff, 0x00cff203
	.long 0x0000ffff, 0x00cf9a00
	.long 0x0000ffff, 0x00cf9200

descriptor4:
	.word 104
	.word 0
	.byte 0
	.byte 0x89
	.byte 0
	.byte 0

descriptor5:
	.word 104
	.word 0
	.byte 0
	.byte 0x89
	.byte 0
	.byte 0

gdt_end:

tss1:
	.word 0, 0
	.long 0
	.word 0, 0
	.long 0
	.word 0, 0
	.long 0
	.word 0, 0
	.long 0, 0, 0
	.long 0, 0, 0, 0
	.long 0, 0, 0, 0
	.word 0, 0
	.word 0, 0
	.word 0, 0
	.word 0, 0
	.word 0, 0
	.word 0, 0
	.word 0, 0
	.word 0, 0

tss2:
	.word 0, 0
	.long 0
	.word 0, 0
	.long 0
	.word 0, 0
	.long 0
	.word 0, 0
	.long 0

tss2_eip:
	.long 0, 0
	.long 0, 0, 0, 0

tss2_esp:
	.long 0, 0, 0, 0
	.word sys_data_selector, 0
	.word sys_code_selector, 0
	.word sys_data_selector, 0
	.word sys_data_selector, 0
	.word sys_data_selector, 0
	.word sys_data_selector, 0
	.word 0, 0
	.word 0, 0

msgPmode:
	.ascii "Hello protected world!!"
	.byte 0
msg_process1:
	.ascii "This is System Process1"
	.byte 0
msg_process2:
	.ascii "This is System Process2"
	.byte 0
