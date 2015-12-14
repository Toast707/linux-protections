# GCC security protections

Heavily modified from https://github.com/majek/dump/tree/master/stack-protector

[stack.c](stack.c) Reserve SIZE bytes of memory calling *alloca(SIZE)* using a local proc pointer *char buf

[core_pattern.sh](core_pattern.sh) Set the kernel core dump file patter. It needs root privileges to run

[fortify.c](fortify.c) Overflow via strncpy SIZE + 0x20

[framepointer.c](framepointer.c) Stack base pointer

[alloca.c](alloca.c) Alloc 0x100 bytes of memory using the procedure "void proc()"

[proc.c](proc.c) Extern definition of "void proc()" used by alloca.c


### Stack protection `-fstack-protector`

```c
static void fun() {
	char *buf;
	buf = alloca(0x100);
}
```

```asm
;; objdump -d -M intel no-stack-protector | awk '/<proc>:/,/ret/'
0000000000400536 <proc>:
  400536:	55                   	push   rbp
  400537:	48 89 e5             	mov    rbp,rsp
  40053a:	48 83 ec 10          	sub    rsp,0x10
  40053e:	48 81 ec 10 01 00 00 	sub    rsp,0x110
  400545:	48 8d 44 24 0f       	lea    rax,[rsp+0xf]
  40054a:	48 83 e0 f0          	and    rax,0xfffffffffffffff0
  40054e:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  400552:	c9                   	leave
  400553:	c3                   	ret
```

```asm
;; objdump -d -M intel stack-protector | awk '/<proc>:/,/ret/'
00000000004005a6 <proc>:
  4005a6:	55                   	push   rbp
  4005a7:	48 89 e5             	mov    rbp,rsp
  4005aa:	48 83 ec 10          	sub    rsp,0x10
  4005ae:	48 81 ec 10 01 00 00 	sub    rsp,0x110
  4005b5:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  4005bc:	00 00
  4005be:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  4005c2:	31 c0                	xor    eax,eax
  4005c4:	48 8d 44 24 0f       	lea    rax,[rsp+0xf]
  4005c9:	48 83 e0 f0          	and    rax,0xfffffffffffffff0
  4005cd:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
  4005d1:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  4005d5:	64 48 33 04 25 28 00 	xor    rax,QWORD PTR fs:0x28
  4005dc:	00 00
  4005de:	74 05                	je     4005e5 <proc+0x3f>
  4005e0:	e8 6b fe ff ff       	call   400450 <__stack_chk_fail@plt>
  4005e5:	c9                   	leave
  4005e6:	c3                   	ret
```

### Part 2. -D_FORTIFY_SOURCE=2

```c
void fun(char *s) {
	char buf[0x100];
	strcpy(buf, s);
}
```

```
;; objdump -d -M intel no-fortified | awk '/<proc>:/,/ret/'
0000000000400576 <proc>:
  400576:	55                   	push   rbp
  400577:	48 89 f2             	mov    rdx,rsi
  40057a:	48 89 fe             	mov    rsi,rdi
  40057d:	48 89 e5             	mov    rbp,rsp
  400580:	53                   	push   rbx
  400581:	48 89 fb             	mov    rbx,rdi
  400584:	48 8d bd f0 fe ff ff 	lea    rdi,[rbp-0x110]
  40058b:	48 81 ec 08 01 00 00 	sub    rsp,0x108
  400592:	e8 79 fe ff ff       	call   400410 <strncpy@plt>
  400597:	48 81 c4 08 01 00 00 	add    rsp,0x108
  40059e:	5b                   	pop    rbx
  40059f:	5d                   	pop    rbp
  4005a0:	c3                   	ret
```

```
;; objdump -d -M intel fortified | awk '/<proc>:/,/ret/'
00000000004005a6 <proc>:
  4005a6:	55                   	push   rbp
  4005a7:	48 89 f2             	mov    rdx,rsi
  4005aa:	48 89 fe             	mov    rsi,rdi
  4005ad:	b9 00 01 00 00       	mov    ecx,0x100
  4005b2:	48 89 e5             	mov    rbp,rsp
  4005b5:	53                   	push   rbx
  4005b6:	48 89 fb             	mov    rbx,rdi
  4005b9:	48 8d bd f0 fe ff ff 	lea    rdi,[rbp-0x110]
  4005c0:	48 81 ec 08 01 00 00 	sub    rsp,0x108
  4005c7:	e8 a4 fe ff ff       	call   400470 <__strncpy_chk@plt>
  4005cc:	48 81 c4 08 01 00 00 	add    rsp,0x108
  4005d3:	5b                   	pop    rbx
  4005d4:	5d                   	pop    rbp
  4005d5:	c3                   	ret
```

