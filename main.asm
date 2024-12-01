.include "macrolib.asm"             
.eqv NAME_SIZE 256                  # ���
.eqv TEXT_SIZE 512                  # �������� ������

.data                               

	file_name: .space NAME_SIZE         # ��� �����
	ask_input: .asciz "Enter path for reading (full):  "   # ��������� ��� ����� ���� � ����� ��� ������
	ask_output: .asciz "Enter path for writing (full):  " # ��������� ��� ����� ���� � ����� ��� ������
	ask_print: .asciz "Do you want to print result? Enter Y/N\n" # ��������� � �������� � ������ ����������
	strbuf1: .space TEXT_SIZE           # ��������������� ����� ��� ������� ������ ������
	choice: .space 2                    # ��������������� ����� ��� ����� ������ ������������

.text 
# s0 - ��������� �����; s1 - -1; s2 - -2; s3 - -3; s4 - -4 
# a1 - ������ ������ �� �����; a2 - ��������� �� ��������� ������� ������ � �������;
# a3 - ����� �� ������ � ����; a4 - ������������ ������ ������ ��� ������   
# a5 - ��������� �� �������� �� ���������                         
main:  
        li s1 -1 # �� �������� �� ���������� ���������, ����� ��� ��������� �������� �������
        li s2 -2
        li s3 -3
        li s4 -4    
                                 
	input(ask_input, file_name, NAME_SIZE)  # ���� � ����� ��� ������ � ��������� ���
	allocate(TEXT_SIZE)                
	
	mv a2, a0                          # a2 ����� ���������� ������
	mv a3, a0                          # a3 ��� ���������
	li a4, TEXT_SIZE                   # ������ ������ ��� ������

	jal read                           # ������ ����������� �����
	la a1, strbuf1                    # ��������� ����� strbuf1 � a1
        jal parsing                        # ������������ ������� ������ (������ � ������)
                                          # a0 - ��������� �� ��������� ������� ������; a1 - �� ������
        mv a2 a0                          # a2 - ��������� �� ��������� ������� ������
        jal check                       # �������� �� ���������; ��������� � a0
        mv a5 a0                        # a5 - ��������� ���������� 
        mv a6 a1
        
	output(ask_output, file_name, NAME_SIZE)  # ��������� ���� � ����� ������
        write(file_name, TEXT_SIZE)   # ���������� ���������

ask:                                 
	la a0, ask_print                  # ��������� ��� ������� � ������ ����������
	la a1, choice                     # ����� choice
	li a2, 2                          # ������������ ����� �����
	li a7, 54                         
	ecall                             
	
	beq a1, s2, cancel_pressed        # ������
	beq a1, s3, empty_input           # ������ ������
	beq a1, s4, too_long_str          # ������� ������

	la t3, choice                     # ����� choice ��� ���������
	li t0, 'Y'                        # ������ 'Y' � t0
	li t1, 'N'                        # ������ 'N' � t1
	lb t2, (t3)                       # ����� ������������ � t2 ��� ������
	beq t0, t2, print                 # ���� 'Y', �� ������� � ������ ����������
	bne t2, t1, ask                   # ���� ����� �� 'N', �� ��������� � �������
	j end                              # ����� ���������

print:                               
	print_string_reg(a5)              # �������   
	
end:                                 
    li a7, 10
    ecall

wrong_name:                          # ��������� ������������� ����� ����� �����
	print_string("Incorrect file name, please try again\n") # ������� ��������� �� ������
	j main                             

cancel_pressed:         # ������
    print_string("You have pressed cancel, reatart if necessary.\n")  
    li a7, 10         
    ecall                   

empty_input:           # �����
    print_string("Empty path, try again.\n")  
    li a7, 10         
    ecall               
    
too_long_str:         # ������
    print_string("The path is too long, try again.\n")
    li a7, 10         
    ecall 
