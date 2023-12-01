
int kernel_main()
{
	asm("int $0x0");
	asm("int $0x1");
	return 0;
}
