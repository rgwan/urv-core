#include "board.h"
#include "uart.h"

#define GPIO_CODR 0x0
#define GPIO_SODR 0x4

#define read_csr(reg) ({ unsigned long __tmp; \
  asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

#define write_csr(reg, val) \
  asm volatile ("csrw " #reg ", %0" :: "r"(val))

main()
{
    volatile int i, j;
    i = 0;
    while(1)
    {
    	writel(0x00010000, 0xff);
    	writel(0x00010000, 0x00);
    	i ++;
    	j += i * i;
    }
}
