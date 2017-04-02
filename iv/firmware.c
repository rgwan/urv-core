
#define GPIOA_ODR (*(volatile char*)0x10000000)

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
	char temp[]="Hello world!";
	char *p = temp;
	while(1)
	{
		while(*p)
		{
			GPIOA_ODR = *p;
			p++;
		}
	}
;
}
