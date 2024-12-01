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

# a0 - что вывести в диалоговом окне; a3 - буффер имени файла; a4 - максимальный размер имени файла
# s0 - дескриптор файла; s1 - -1; s2 - -2; s3 - -3; s4 - -4
.macro input(%message, %strbuf, %size)
    la a0 %message
    la a3 %strbuf
    li a4 %size
    jal input
    open(a3, 0) # в a0 дескритор файла
    beq a0 s1 wrong_name # если что-то не так
    mv s0 a0 # дескриптор, в процессе работы программы s0 не трогается
.end_macro

.macro open(%file_name, %opt)
    li   a7 1024     
    mv   a0 %file_name  # имя файла
    li   a1 %opt # запись (1)/открытие (0)    	
    ecall             		
.end_macro

# В a0 - указатель на выделенную память
.macro allocate(%size)
    li a7, 9
    li a0, %size	
    ecall
.end_macro

# a0 - возврат длина считанного
.macro read_addr_reg(%file_descriptor, %reg, %size)
    li   a7, 63       	
    mv   a0, %file_descriptor   # дескриптор
    mv   a1, %reg   	        # буффер
    mv   a2, %size 		# максимальная длина
    ecall             	
.end_macro

# дополнительно выделяем память с размером в регистре
.macro allocate_reg(%size)
    li a7, 9
    mv a0, %size	
    ecall
.end_macro

# закрываем файл
.macro close(%file_descriptor)
    li   a7, 57      
    mv   a0, %file_descriptor  
    ecall             
.end_macro

# считывание имени файла для записи
.macro output(%message, %strbuf, %size)
    la a0 %message
    la a3 %strbuf
    li a4 %size
    jal output
.end_macro

# записывание результата в файл
.macro write(%file_name, %size)
    la a1 %file_name
    li a2 %size
    open(a1, 1)
    beq  a0 s1 wrong_name
    mv s6 a0 # дескриптор
    jal write
    close(s6)    
.end_macro

# тестовая программа
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
