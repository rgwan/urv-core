
#define GPIOA_ODR (*(volatile char*)0x10000000)
/*
void *memcpy(void *dest, const void *src, int n)
{
	while (n) 
	{
		n--;
		((char*)dest)[n] = ((char*)src)[n];
	}
	return dest;
}
*/

void __attribute__((noinline)) write (char a)
{
	GPIOA_ODR = a;
}
void main()
{
	/*char a[] = "1234567890";
	int c = 0;

	while(c < sizeof(a))
	{
		GPIOA_ODR = a[c++];
	}	
	
	while(1);*/
	volatile char a[10];
	int i;
	for(i = 0; i < 10; i++)
		a[i] = i;
	
	for(i = 0; i< 10; i++)
		write(a[i]);
	while(1);
;
}
