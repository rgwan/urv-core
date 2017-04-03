#define GPIO_A_ODR (*(volatile char*)0x10000000)

void main()
{
	int i;
	volatile char a[10];
	for(i = 0; i < 10; i++)
	{
		a[i] = i + 0x30;
	}
	for(i = 0; i < 10; i++)
	{
		GPIO_A_ODR = a[i];
	}
	GPIO_A_ODR='\n';
	while(1);
}
