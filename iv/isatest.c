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
void main()
{
	int i;
	while(1)
	{
		GPIO_A_ODR = 0x55;
		GPIO_A_ODR = 0x56;
	}
}
