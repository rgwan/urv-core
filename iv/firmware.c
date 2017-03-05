
#define GPIO_A_ODR (*(volatile char*)0x10000000)
void putc(char c)
{
	GPIO_A_ODR = c;
}

void puts(const char *s)
{
	volatile int j;
	while (*s)
	{
		putc(*s++);
	}
}


void *memcpy(void *dest, const void *src, int n)
{
	while (n) 
	{
		n--;
		((char*)dest)[n] = ((char*)src)[n];
	}
	return dest;
}

void main()
{
	char message[] = "$Uryyb+Jbeyq!+Vs+lbh+pna+ernq+guvf+zrffntr+gura$gur+EI32+PCH"
			"+frrzf+gb+or+jbexvat+whfg+svar.$$++++++++++++++++GRFG+CNFFRQ!$$";
	char dismessage[sizeof(message)];
	
	memcpy(dismessage, message, sizeof(message));
	for (int i = 0; message[i]; i++)
		switch (message[i])
		{
		case 'a' ... 'm':
		case 'A' ... 'M':
			message[i] += 13;
			break;
		case 'n' ... 'z':
		case 'N' ... 'Z':
			message[i] -= 13;
			break;
		case '$':
			message[i] = '\n';
			break;
		case '+':
			message[i] = ' ';
			break;
		}
	while(1)
	{
		putc(0x00);
		putc(0x7f);
	}
}

