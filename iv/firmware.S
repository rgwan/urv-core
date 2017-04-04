.section .init
.global main

/* set stack pointer */
lui sp, %hi(4*1024)
addi sp, sp, %lo(4*1024)

/* call main */
jal ra, main


/*
li a1, 0x400
li a2, 0xaa
li a3, 0x55

sb a2, 0(a1) //aa

lbu a4, 0(a1) 

sb a2, 1(a1) //aa

lbu a5, 1(a1)

sb a3, 2(a1) //55

lbu a6, 2(a1)

sb a2, 3(a1) //aa

lbu a7, 3(a1)

li a1, 0x00

lw a2, 0(a1)
lw a2, 4(a1)
lw a2, 8(a1)
lw a2, 12(a1)

li a1, 0x400
sw a2, 0(a1)

loop:
lw a2, 0(a1)
addi a2, a2, 1
sw a2, 0(a1)
j loop
*/

sbreak
/* break */

