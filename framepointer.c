#include <stdio.h>
#include <stdlib.h>

char buf;

__attribute__((noinline)) void proc2(int b) {
    asm volatile("" :: "m" (buf));
}

__attribute__((noinline)) void proc(int a) {
    asm volatile("" :: "m" (buf));
    proc2(2);
    asm volatile("" :: "m" (buf));
}


int main() {
    printf("[+] start\n");
    proc(1);
    printf("[+] end\n");
    return 0;
}
