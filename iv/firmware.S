.section .init
.global main

/* set stack pointer */
startup:
ori x1, x0, 0x7f
a:
ori x2, x1, 1
ori x3, x2, 8
li x5, 0x10000000
loop:
sb x1, 0(x5)
sw x0, 0(x5)
j loop
nop
nop
nop
nop
b:
ebreak

