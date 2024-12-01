.include "macrolib.asm"
.global write

# s6 - дескриптор
# a5 - буффер для записи; a6 - длина записываемого буффера
write:
    addi sp sp -4
    sw ra (sp)
    li   a7, 64       
    mv   a0, s6      
    mv   a1, a5   
    mv a2 a6
    ecall            
    lw ra (sp)
    addi sp sp 4
    ret
