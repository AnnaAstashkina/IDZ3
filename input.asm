.include "macrolib.asm" 
.global input           

# a0 - строка для вывода в диалоговое окно; a3 - имя файла, a4 - максимальный размер
# t0 - \n; t1 - буффер имени файла (указатель на элемент); t2 - нфнешний элемент строки
# s1 - -1; s2 - -2; s3 - -3; s4 - -4
input:                  
    addi sp, sp, -4      # Сохраняем ra
    sw ra, (sp)         
loop:
    mv a1, a3            # a3 - имя файла в a1 для считывания
    mv a2, a4            # a4 - максимальный размер в a2 для считывания
    
    li a7, 54            # загрузка команды для считывания имени файла
    ecall                # в a1 - результат выполнения

    beq a1, s2, cancel_pressed   # слишком отмена
    beq a1, s3, empty_input      # слишком пусто
    beq a1, s4, too_long_str     # слишком длинно

    li t0, '\n'            
    mv t1, a3             # указатель на элемент имени файла

next:                   
    lb t2, (t1)         # нынешний элемент
    beq t2, t0, replace   # нашли перевод строки
    addi t1, t1, 1       # идем дальше
    b next               

replace:               
    sb zero, (t1)      # заменяем \n на 0
    lw ra, (sp)         # осстанавливаем ra
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
