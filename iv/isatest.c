#define GPIO_A_ODR (*(volatile char*)0x10000000)

void *memcpy(void *dest, const void *src, int n)
{
	while (n) 
	{
		n--;
		((char*)dest)[n] = ((char*)src)[n];
	}
	return dest;
}


void puts(char *s)
{
	while(1)
	{
		GPIO_A_ODR = *s;
		s++;
		if(*s == 0)
			break;
	}
}

void putc(char c)
{
	GPIO_A_ODR = c;
}
void printhex(char i)
{
	char table[]="0123456789ABCDEF";
	
	putc(table[i >> 4]);
	putc(table[i & 0x0f]);
}

void printcrlf()
{
	putc('\r');
	putc('\n');
}
void dump_memory(int address, int size)
{
	int i;
	char *dat = (char *)address;
	int disp_address;
	puts("Dump memory from 0x");
	printhex(disp_address >> 24);
	printhex(disp_address >> 16);
	printhex(disp_address >> 8);
	printhex(disp_address & 0xff);	
	puts(" size: 0x");
	printhex(size >> 8);
	printhex(size & 0xff);	
	printcrlf();	
	for(i = 0; i < size; i++)
	{
		if(i % 16 == 0)
		{
			disp_address = address + i;
			printcrlf();
			printhex(disp_address >> 24);
			printhex(disp_address >> 16);
			printhex(disp_address >> 8);
			printhex(disp_address & 0xff);
			putc(' ');
		}
		printhex(dat[i]);
		putc(' ');
	}
}

void main()
{
	int i;
	puts("System start\r\n");
	//dump_memory(0, 0x100);
	puts("Done\r\n");
}
