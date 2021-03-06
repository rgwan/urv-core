#include "riscv_test.h"

#ifdef __riscv64
# define STORE    sd
# define LOAD     ld
# define REGBYTES 8
#else
# define STORE    sw
# define LOAD     lw
# define REGBYTES 4
#endif

#define STACK_TOP (_end + 131072)

  .section ".text.init","ax",@progbits
  .align 6
entry_from_user:
  mrts

  .align 6
entry_from_supervisor:
  csrr t0, mcause
  addi t0, t0, -CAUSE_SUPERVISOR_ECALL
  beqz t0, handle_tohost
  j wtf

  .align 6
entry_from_hypervisor:
  j wtf

  .align 6
entry_from_machine:
  csrr t0, mcause
  addi t0, t0, -CAUSE_MACHINE_ECALL
  beqz t0, handle_tohost
  j wtf

  .align 6
power_on_reset:
  la sp, STACK_TOP - SIZEOF_TRAPFRAME_T
  csrw mscratch, sp
  li a1, 1337
  la a0, userstart
  j vm_boot

  .globl  pop_tf
pop_tf:
  csrc sstatus, SSTATUS_IE
  LOAD  t0,33*REGBYTES(a0)
  csrw  sepc,t0
  LOAD  x1,1*REGBYTES(a0)
  LOAD  x2,2*REGBYTES(a0)
  LOAD  x3,3*REGBYTES(a0)
  LOAD  x4,4*REGBYTES(a0)
  LOAD  x5,5*REGBYTES(a0)
  LOAD  x6,6*REGBYTES(a0)
  LOAD  x7,7*REGBYTES(a0)
  LOAD  x8,8*REGBYTES(a0)
  LOAD  x9,9*REGBYTES(a0)
  LOAD  x11,11*REGBYTES(a0)
  LOAD  x12,12*REGBYTES(a0)
  LOAD  x13,13*REGBYTES(a0)
  LOAD  x14,14*REGBYTES(a0)
  LOAD  x15,15*REGBYTES(a0)
  LOAD  x16,16*REGBYTES(a0)
  LOAD  x17,17*REGBYTES(a0)
  LOAD  x18,18*REGBYTES(a0)
  LOAD  x19,19*REGBYTES(a0)
  LOAD  x20,20*REGBYTES(a0)
  LOAD  x21,21*REGBYTES(a0)
  LOAD  x22,22*REGBYTES(a0)
  LOAD  x23,23*REGBYTES(a0)
  LOAD  x24,24*REGBYTES(a0)
  LOAD  x25,25*REGBYTES(a0)
  LOAD  x26,26*REGBYTES(a0)
  LOAD  x27,27*REGBYTES(a0)
  LOAD  x28,28*REGBYTES(a0)
  LOAD  x29,29*REGBYTES(a0)
  LOAD  x30,30*REGBYTES(a0)
  LOAD  x31,31*REGBYTES(a0)
  LOAD  a0,10*REGBYTES(a0)
  eret

  .global  trap_entry
trap_entry:
  csrrw sp, sscratch, sp

  # save gprs
  STORE  x1,1*REGBYTES(sp)
  STORE  x3,3*REGBYTES(sp)
  STORE  x4,4*REGBYTES(sp)
  STORE  x5,5*REGBYTES(sp)
  STORE  x6,6*REGBYTES(sp)
  STORE  x7,7*REGBYTES(sp)
  STORE  x8,8*REGBYTES(sp)
  STORE  x9,9*REGBYTES(sp)
  STORE  x10,10*REGBYTES(sp)
  STORE  x11,11*REGBYTES(sp)
  STORE  x12,12*REGBYTES(sp)
  STORE  x13,13*REGBYTES(sp)
  STORE  x14,14*REGBYTES(sp)
  STORE  x15,15*REGBYTES(sp)
  STORE  x16,16*REGBYTES(sp)
  STORE  x17,17*REGBYTES(sp)
  STORE  x18,18*REGBYTES(sp)
  STORE  x19,19*REGBYTES(sp)
  STORE  x20,20*REGBYTES(sp)
  STORE  x21,21*REGBYTES(sp)
  STORE  x22,22*REGBYTES(sp)
  STORE  x23,23*REGBYTES(sp)
  STORE  x24,24*REGBYTES(sp)
  STORE  x25,25*REGBYTES(sp)
  STORE  x26,26*REGBYTES(sp)
  STORE  x27,27*REGBYTES(sp)
  STORE  x28,28*REGBYTES(sp)
  STORE  x29,29*REGBYTES(sp)
  STORE  x30,30*REGBYTES(sp)
  STORE  x31,31*REGBYTES(sp)

  csrrw  t0,sscratch,sp
  STORE  t0,2*REGBYTES(sp)

  # get sr, epc, badvaddr, cause
  csrr   t0,sstatus
  STORE  t0,32*REGBYTES(sp)
  csrr   t0,sepc
  STORE  t0,33*REGBYTES(sp)
  csrr   t0,sbadaddr
  STORE  t0,34*REGBYTES(sp)
  csrr   t0,scause
  STORE  t0,35*REGBYTES(sp)

  # get hwacha cause if IRQ_COP
  # vxcptcause clears hwacha interrupt bit

  bgez  t0,1f
  slli  t0,t0,1 # clearing MSB of cause
  srli  t0,t0,1 # clearing MSB of cause
  li    t1,IRQ_COP
  bne   t0,t1,1f
  vxcptcause t0
  STORE  t0,36*REGBYTES(sp)
1:

  move  a0, sp
  csrr  t0, sstatus
  li    t1, SSTATUS_XS
  and   t0, t0, t1
  beqz  t0, 2f

  # disable saving vector state for now
  addi  t0,sp,SIZEOF_TRAPFRAME_T_SCALAR

  vgetcfg x4
  STORE x4,0*REGBYTES(t0)
  vgetvl x4
  STORE x4,1*REGBYTES(t0)
  addi  t0,t0,2*REGBYTES
  vxcptevac t0
2:j handle_trap

  .global do_tohost
do_tohost:
  ecall
  ret

handle_tohost:
1:csrrw t0, mtohost, a0
  bnez t0, 1b

1:csrrw t0, mfromhost, x0
  bnez t0, 1b

  csrr t0, mepc
  addi t0, t0, 4
  csrw mepc, t0
  eret

wtf:
  li a0, 841
1:csrw mtohost, a0
  j 1b
