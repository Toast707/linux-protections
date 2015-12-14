.PHONY: all clean
.SILENT: all clean

CC := gcc
SRC := $(shell ls *.c)
OBJ := $(SRC:.c=.o)
BIN := $(SRC:.c=)

ARCH := $(shell getconf LONG_BIT)

CFLAGS_64 := -Os -Wno-unused-parameter
CFLAGS_32 := -m32 $(CFLAGS_64)
DEBUG_CFLAGS := -Wall -Wextra -g -ggdb
CFLAGS := $(CFLAGS_$(ARCH))
TARGETS := stack-protector no-stack-protector fortified no-fortified omit-frame-pointer no-omit-frame-pointer alloca

all: $(TARGETS)

no-stack-protector: stack.c
	$(CC) $(CFLAGS) $< -o $@ -fno-stack-protector -U_FORTIFY_SOURCE -fno-omit-frame-pointer

stack-protector: stack.c
	$(CC) $(CFLAGS) $< -o $@ -fstack-protector -U_FORTIFY_SOURCE -fno-omit-frame-pointer

no-fortified: fortify.c
	$(CC) $(CFLAGS) $< -o $@ -fno-stack-protector -U_FORTIFY_SOURCE -fno-omit-frame-pointer

fortified: fortify.c
	$(CC) $(CFLAGS) $< -o $@ -fno-stack-protector -D_FORTIFY_SOURCE=2 -fno-omit-frame-pointer

omit-frame-pointer: framepointer.c
	$(CC) $(CFLAGS) $< -o $@ -fomit-frame-pointer

no-omit-frame-pointer: framepointer.c
	$(CC) $(CFLAGS) $< -o $@ -fno-omit-frame-pointer

alloca.o: alloca.c
	$(CC) $(CFLAGS) $^ -c -o $@ -fno-omit-frame-pointer

proc.o: proc.c
	$(CC) $(CFLAGS) $^ -c -o $@ -fno-omit-frame-pointer

alloca: alloca.o proc.o
	$(CC) $(CFLAGS) $^ -o $@ -fno-omit-frame-pointer

clean:
	rm $(TARGETS) *.o


