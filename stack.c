#include <stdio.h>
#include <stdlib.h>

#define SIZE 0x100

__attribute__((noinline)) void proc() {
    char *buf = alloca(SIZE);
    /* Make sure the compiler doens't optimize away the buf */
    asm volatile("" :: "m" (buf));
}

int main() {
	printf("[+] start\n");
	proc();
	printf("[+] end\n");
	return 0;
}
