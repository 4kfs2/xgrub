times 63 dd 0
user_1_stack:
user_1_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd user_process1
	dw u_code_selector, 0
	dd 0x200
	dd user_1_stack
	dw u_data_selector, 0	
	
times 63 dd 0
user_2_stack:
user_2_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd user_process2
	dw u_code_selector, 0
	dd 0x200
	dd user_2_stack
	dw u_data_selector, 0	
	
times 63 dd 0
user_3_stack:
user_3_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd user_process3
	dw u_code_selector, 0
	dd 0x200
	dd user_3_stack
	dw u_data_selector, 0	
	
times 63 dd 0
user_4_stack:
user_4_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd user_process4
	dw u_code_selector, 0
	dd 0x200
	dd user_4_stack
	dw u_data_selector, 0	
	
times 63 dd 0
user_5_stack:
user_5_regs:
	dd 0, 0, 0, 0, 0, 0, 0, 0

	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0
	dw u_data_selector, 0

	dd user_process5
	dw u_code_selector, 0
	dd 0x200
	dd user_5_stack
	dw u_data_selector, 0	
	