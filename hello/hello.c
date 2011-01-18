#include <stdio.h>
#include <errno.h>

int	main()
{	char* str = "Err in Hello, world";
	errno = 0;
	printf("Hello, world!\n");
	if(errno!=0)
	{	perror(str);
		return 1;
	}
	system("pause");
	return 0;
}