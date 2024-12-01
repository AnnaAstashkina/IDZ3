.include "macrolib.asm"
.data
	file1: .asciz "C:\\Users\\Anna\\2curs\\avs\\IDZ3\\test1.txt"
	correct1: .asciz "palindrom"
	
	file2: .asciz "C:\\Users\\Anna\\2curs\\avs\\IDZ3\\test2.txt"
	correct2: .asciz "palindrom"
	
	file3: .asciz "C:\\Users\\Anna\\2curs\\avs\\IDZ3\\test3.txt"
	correct3: .asciz "not palindrom"
	
	file4: .asciz "C:\\Users\\Anna\\2curs\\avs\\IDZ3\\test4.txt"
	correct4: .asciz "not palindrom"
.text
	test(file1, correct1)
	test(file2, correct2)
	test(file3, correct3)
	test(file4, correct4)
	li a7, 10
        ecall
