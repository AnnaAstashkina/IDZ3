.include "macrolib.asm"
.global check
.data
yes: .asciz "palindrom"   # ��������� ��� ����� ���� � ����� ��� ������
no: .asciz "not palindrom" 
# a0 - ���� ����������: 1 - ���������, 0 - �� ���������
# a1 - ����� ������� ��������� ������; a2 - ��������� �� ��������� ������� ������
# t0 - ������� � ������; t1 - ������� � �����
# t2 - ��������� �� �������� ������� � ������; t3 - ��������� �� �������� ������� � �����
.text
check:
    addi sp, sp, -4
    sw ra, (sp)
    mv t2, a1             # t2 - ��������� �� �������� ������� � ������
    mv t3, a2             # t3 - ��������� �� �������� ������� � �����
    li a0 1               # ���� ����������: 1 - ���������, 0 - �� ���������

loop:
    lb t0, (t2)           # t0 - ������� � ������
    beq t0, zero, end     # ���� ����� => ����� ������
    lb t1, (t3)           # t1 - ������� � �����
    bne t0, t1, not_eqv   # ���� �� ���������
    addi t2, t2, 1          # ��������� �������
    addi t3, t3, -1         # ���������� �������
    j loop
    
not_eqv:
    li a0, 0               # ���� ������������ => �� ���������
    j end

noo:
    la a0, no
    li a1 13
    j endend
    
end:
    beqz a0 noo
    la a0, yes
    li a1 9
    
endend:
    # � a0 - ���������
    # a1 - �����
    lw ra, (sp)           # ���������� ra
    addi sp, sp, 4
    ret     
              
