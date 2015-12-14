#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define SIZE 0x100

void proc(unsigned char *buf, size_t size) 
{
	unsigned char localbuf[SIZE];
	strncpy(localbuf, buf, size);
	asm volatile("" :: "m" (buf[0]));
}

int main(int argc, char **argv) 
{
	printf("[i] strncpy\n");
	proc(argv[0], SIZE + 0x20);
	printf("[i] done\n");
	return 0;
}
