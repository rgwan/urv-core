.section .init
.global main

/* set stack pointer */
lui sp, %hi(3*1024)
addi sp, sp, %lo(3*1024)

/* call main */
jal ra, main

/* break */
ebreak
