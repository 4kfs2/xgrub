user_process1:
	mov eax, 80*2*2+2*5
	lea ebx, [msg_user_process1_1]
	int 0x80
	mov eax, 80*2*3+2*5
	lea ebx, [msg_user_process1_2]
	int 0x80
	inc byte [msg_user_process1_2]
	jmp user_process1

	msg_user_process1_1 db "User process1", 0
	msg_user_process1_2 db ".I'm running now.", 0

user_process2:
	mov eax, 80*2*2 + 2*35
	lea ebx, [msg_user_process2_1]
	int 0x80
	mov eax, 80*2*3 + 2*35
	lea ebx, [msg_user_process2_2]
	int 0x80
	inc byte [msg_user_process2_2]
	jmp user_process2

	msg_user_process2_1 db "User process2", 0
	msg_user_process2_2 db ".I'm running now.", 0

user_process3:
	mov eax, 80*2*5 + 2*5
	lea ebx, [msg_user_process3_1]
	int 0x80
	mov eax, 80*2*6 + 2*5
	lea ebx, [msg_user_process3_2]
	int 0x80
	inc byte [msg_user_process3_2]
	jmp user_process3

	msg_user_process3_1 db "User process3", 0
	msg_user_process3_2 db ".I'm running now.", 0

user_process4:
	mov eax, 80*2*5 + 2*35
	lea ebx, [msg_user_process4_1]
	int 0x80
	mov eax, 80*2*6 + 2*35
	lea ebx, [msg_user_process4_2]
	int 0x80
	inc byte [msg_user_process4_2]
	jmp user_process4

	msg_user_process4_1 db "User process4", 0
	msg_user_process4_2 db ".I'm running now.", 0

user_process5:
	mov eax, 80*2*9 + 2*5
	lea ebx, [msg_user_process5_1]
	int 0x80
	mov eax, 80*2*10 + 2*5
	lea ebx, [msg_user_process5_2]
	int 0x80
	inc byte [msg_user_process5_2]
	jmp user_process5

	msg_user_process5_1 db "User process5", 0
	msg_user_process5_2 db ".I'm running now.", 0

