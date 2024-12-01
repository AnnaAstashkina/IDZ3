.include "macrolib.asm"             
.eqv NAME_SIZE 256                  # Имя
.eqv TEXT_SIZE 512                  # Заданная строка

.data                               

	file_name: .space NAME_SIZE         # Имя файла
	ask_input: .asciz "Enter path for reading (full):  "   # Сообщение для ввода пути к файлу для чтения
	ask_output: .asciz "Enter path for writing (full):  " # Сообщение для ввода пути к файлу для записи
	ask_print: .asciz "Do you want to print result? Enter Y/N\n" # Сообщение с вопросом о выводе результата
	strbuf1: .space TEXT_SIZE           # Зарезервировать место для первого буфера строки
	choice: .space 2                    # Зарезервировать место для ввода выбора пользователя

.text 
# s0 - дескритор файла; s1 - -1; s2 - -2; s3 - -3; s4 - -4 
# a1 - буффер строки из файла; a2 - указатель на последний элемент строки в буффере;
# a3 - адрес на строку в куче; a4 - максимальный размер текста для чтения   
# a5 - результат на проверку на палиндром                         
main:  
        li s1 -1 # не меняются на протяжении программы, нужны для обработки возврата функций
        li s2 -2
        li s3 -3
        li s4 -4    
                                 
	input(ask_input, file_name, NAME_SIZE)  # путь к файлу для чтения и сохранить его
	allocate(TEXT_SIZE)                
	
	mv a2, a0                          # a2 адрес выделенной памяти
	mv a3, a0                          # a3 для указателя
	li a4, TEXT_SIZE                   # размер текста для чтения

	jal read                           # чтение содержимого файла
	la a1, strbuf1                    # загружаем адрес strbuf1 в a1
        jal parsing                        # обрабатываем входные данные (чтение в буффер)
                                          # a0 - указатель на последний элемент строки; a1 - на первый
        mv a2 a0                          # a2 - указатель на последний элемент строки
        jal check                       # проверка на палиндром; результат в a0
        mv a5 a0                        # a5 - результат палиндрома 
        mv a6 a1
        
	output(ask_output, file_name, NAME_SIZE)  # считываем путь к файлу записи
        write(file_name, TEXT_SIZE)   # записываем результат

ask:                                 
	la a0, ask_print                  # сообщение для запроса о выводе результата
	la a1, choice                     # место choice
	li a2, 2                          # максимальная длина ввода
	li a7, 54                         
	ecall                             
	
	beq a1, s2, cancel_pressed        # отмена
	beq a1, s3, empty_input           # пустая строка
	beq a1, s4, too_long_str          # длинная строка

	la t3, choice                     # адрес choice для сравнения
	li t0, 'Y'                        # символ 'Y' в t0
	li t1, 'N'                        # символ 'N' в t1
	lb t2, (t3)                       # выбор пользователя в t2 для оценки
	beq t0, t2, print                 # если 'Y', то перейти к выводу результата
	bne t2, t1, ask                   # если выбор не 'N', то вернуться к запросу
	j end                              # иначе завершаем

print:                               
	print_string_reg(a5)              # выводим   
	
end:                                 
    li a7, 10
    ecall

wrong_name:                          # Обработка неправильного ввода имени файла
	print_string("Incorrect file name, please try again\n") # Вывести сообщение об ошибке
	j main                             

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
