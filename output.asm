.include "macrolib.asm"         
.global output                        
.data                               

	default_name: .asciz "testout.txt"  # дефолтное имя файла
.text      
# a5 - результат проверки на палиндром
# a3 - имя файла; a4 - размер 
# t0 - \n; t5 - указатель на нынешний; t3 - указатель на начало; t6 - нынешний символ       
output:                              
	addi sp, sp, -4                 
	sw ra, (sp)                    
	mv a1, a3                          # имя файла
	mv a2, a4                          # размер
	li a7, 54                          
	ecall                              

	beq a1, s2, cancel_pressed         # сликшом отмена
	beq a1, s3, empty_input            # слишком пусто
	beq a1, s4, too_long_str           # слишком длинно
	li t0, '\n'                        
	mv t5, a3                          # указатель на нынешний
	mv t3, t5                          # указатель на начало

loop:                                
	lb t6, (t5)                       # t6 - символ
	beq t6, t0, replace                # Iесли равен \n
	addi t5, t5, 1                     # переход на следующий
	j loop                              

replace:                             
	beq t3, t5, default                # переход на дефолтное имя
	sb zero, (t5)                     # закидываем 0 в конец
	mv a0, t3                          # в a0 для возврата имени
	lw ra, (sp)                       
	addi sp, sp, 4
	ret                                 

default:                             
	la a0, default_name                # закидываем дефолтное имя
	lw ra, (sp)                       
	addi sp, sp, 4                     
	ret                                 


cancel_pressed:         # отмена
    print_string("You have pressed cancel, reatart if necessary.\n")  
    li a7, 10         
    ecall                   

empty_input:           # пусто
    print_string("Empty path, try again.\n")  
    li a7, 10         
    ecall               
    
too_long_str:         # длинно
    print_string("The path is too long, try again.\n")
    li a7, 10         
    ecall 

