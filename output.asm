.include "macrolib.asm"         
.global output                        
.data                               

	default_name: .asciz "testout.txt"  # ��������� ��� �����
.text      
# a5 - ��������� �������� �� ���������
# a3 - ��� �����; a4 - ������ 
# t0 - \n; t5 - ��������� �� ��������; t3 - ��������� �� ������; t6 - �������� ������       
output:                              
	addi sp, sp, -4                 
	sw ra, (sp)                    
	mv a1, a3                          # ��� �����
	mv a2, a4                          # ������
	li a7, 54                          
	ecall                              

	beq a1, s2, cancel_pressed         # ������� ������
	beq a1, s3, empty_input            # ������� �����
	beq a1, s4, too_long_str           # ������� ������
	li t0, '\n'                        
	mv t5, a3                          # ��������� �� ��������
	mv t3, t5                          # ��������� �� ������

loop:                                
	lb t6, (t5)                       # t6 - ������
	beq t6, t0, replace                # I���� ����� \n
	addi t5, t5, 1                     # ������� �� ���������
	j loop                              

replace:                             
	beq t3, t5, default                # ������� �� ��������� ���
	sb zero, (t5)                     # ���������� 0 � �����
	mv a0, t3                          # � a0 ��� �������� �����
	lw ra, (sp)                       
	addi sp, sp, 4
	ret                                 

default:                             
	la a0, default_name                # ���������� ��������� ���
	lw ra, (sp)                       
	addi sp, sp, 4                     
	ret                                 


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

