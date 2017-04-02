
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
	char a[] = "Hello world!\n";
	int c = 0;

	while(c < sizeof(a))
	{
		GPIOA_ODR = a[c++];
	}	
	
	while(1);
;
}
