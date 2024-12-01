.macro print_string %string
.data
	print: .asciz %string
.text
	la a0 print
	li a1 1
	li a7 55
	ecall
.end_macro

.macro print_string_reg %register
	mv a0 %register
	li a1 1
	li a7 55
	ecall
.end_macro

.macro print_string_addr(%register)
	la a0 %register
	li a1 1
	li a7 55
	ecall
.end_macro

# a0 - ��� ������� � ���������� ����; a3 - ������ ����� �����; a4 - ������������ ������ ����� �����
# s0 - ���������� �����; s1 - -1; s2 - -2; s3 - -3; s4 - -4
.macro input(%message, %strbuf, %size)
    la a0 %message
    la a3 %strbuf
    li a4 %size
    jal input
    open(a3, 0) # � a0 ��������� �����
    beq a0 s1 wrong_name # ���� ���-�� �� ���
    mv s0 a0 # ����������, � �������� ������ ��������� s0 �� ���������
.end_macro

.macro open(%file_name, %opt)
    li   a7 1024     
    mv   a0 %file_name  # ��� �����
    li   a1 %opt # ������ (1)/�������� (0)    	
    ecall             		
.end_macro

# � a0 - ��������� �� ���������� ������
.macro allocate(%size)
    li a7, 9
    li a0, %size	
    ecall
.end_macro

# a0 - ������� ����� ����������
.macro read_addr_reg(%file_descriptor, %reg, %size)
    li   a7, 63       	
    mv   a0, %file_descriptor   # ����������
    mv   a1, %reg   	        # ������
    mv   a2, %size 		# ������������ �����
    ecall             	
.end_macro

# ������������� �������� ������ � �������� � ��������
.macro allocate_reg(%size)
    li a7, 9
    mv a0, %size	
    ecall
.end_macro

# ��������� ����
.macro close(%file_descriptor)
    li   a7, 57      
    mv   a0, %file_descriptor  
    ecall             
.end_macro

# ���������� ����� ����� ��� ������
.macro output(%message, %strbuf, %size)
    la a0 %message
    la a3 %strbuf
    li a4 %size
    jal output
.end_macro

# ����������� ���������� � ����
.macro write(%file_name, %size)
    la a1 %file_name
    li a2 %size
    open(a1, 1)
    beq  a0 s1 wrong_name
    mv s6 a0 # ����������
    jal write
    close(s6)    
.end_macro

# �������� ���������
.macro test(%file_name, %correct)
.data
	file_name: .space 256
	strbuf1: .space 512
.text
        li s1 -1
        li s2 -2
        li s3 -3
        li s4 -4  
	la a2 %file_name
	print_string("File name: ")
	print_string_reg(a2)
	
	print_string("Expected result: ")
	print_string_addr(%correct)

	open(a2, 0)
    	beq a0 s1 error_open
    	mv s0 a0
	allocate(256)
	mv a2 a0
	mv a3 a0
	li a4 512
	
	jal read
	close(s0)
	
	la a1 strbuf1
	jal parsing
	
        mv a2 a0                         
        jal check                      
        mv a5 a0                        
        mv a6 a1
	
	print_string("Real result: ")
	print_string_reg(a5)
	
	j end
error_open:
	print_string("Error while opening file\n")
end:	
.end_macro

.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro
