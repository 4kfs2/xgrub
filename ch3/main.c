void func1(char *str)
{
	(void)str;
}

int kernel_main()
{
	char *str = "hihihi!! with c";
	func1(str);
	printf();
	return 0;
}
