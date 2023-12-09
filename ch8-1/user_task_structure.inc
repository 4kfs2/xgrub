times 63 dd 0
user_1_stack:
user_1_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd 0x80000000			; EIP
	dw u_code_selector, 0
	dd 0x200
	dd 0x80000FFF			; ESP
	dw u_data_selector, 0	
	
times 63 dd 0
user_2_stack:
user_2_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd 0x80001000
	dw u_code_selector, 0
	dd 0x200
	dd 0x80001FFF
	dw u_data_selector, 0	
	
times 63 dd 0
user_3_stack:
user_3_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd 0x80002000
	dw u_code_selector, 0
	dd 0x200
	dd 0x80002FFF
	dw u_data_selector, 0	
	
times 63 dd 0
user_4_stack:
user_4_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd 0x80003000
	dw u_code_selector, 0
	dd 0x200
	dd 0x80003FFF
	dw u_data_selector, 0	
	
times 63 dd 0
user_5_stack:
user_5_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd 0x80004000
	dw u_code_selector, 0
	dd 0x200
	dd 0x80004FFF
	dw u_data_selector, 0	
	