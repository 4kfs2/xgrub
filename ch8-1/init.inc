sys_code_selector 	equ 0x08
sys_data_selector 	equ 0x10
video_selector 		equ 0x18
tss_selector 		equ 0x20
u_code_selector 	equ 0x28 + 3
u_data_selector 	equ 0x30 + 3

IDT_BASE			equ 0xC0001000
TSS_ESP0_WHERE		equ 0x90000
