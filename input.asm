.include "macrolib.asm" 
.global input           

# a0 - ������ ��� ������ � ���������� ����; a3 - ��� �����, a4 - ������������ ������
# t0 - \n; t1 - ������ ����� ����� (��������� �� �������); t2 - �������� ������� ������
# s1 - -1; s2 - -2; s3 - -3; s4 - -4
input:                  
    addi sp, sp, -4      # ��������� ra
    sw ra, (sp)         
loop:
    mv a1, a3            # a3 - ��� ����� � a1 ��� ����������
    mv a2, a4            # a4 - ������������ ������ � a2 ��� ����������
    
    li a7, 54            # �������� ������� ��� ���������� ����� �����
    ecall                # � a1 - ��������� ����������

    beq a1, s2, cancel_pressed   # ������� ������
    beq a1, s3, empty_input      # ������� �����
    beq a1, s4, too_long_str     # ������� ������

    li t0, '\n'            
    mv t1, a3             # ��������� �� ������� ����� �����

next:                   
    lb t2, (t1)         # �������� �������
    beq t2, t0, replace   # ����� ������� ������
    addi t1, t1, 1       # ���� ������
    b next               

replace:               
    sb zero, (t1)      # �������� \n �� 0
    lw ra, (sp)         # �������������� ra
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
