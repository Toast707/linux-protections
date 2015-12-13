CC := gcc
SRC := $(shell ls *.c)
OBJ := $(SRC:.c=.o)
BIN := $(src:.c=)

CFLAGS := $(CFLAGS) -Os -Wno-unused-parameter -Wall -Wextra -g -ggdb -m32
TARGETS = fno-stack-protector fstack-protector fno-omit-frame-pointer fomit-frame-pointer unfortified fortified alloca

.PHONY: all clean
.SILENT: all clean


all:  $(TARGETS)


fno-stack-protector: fstack-protector.c
	$(CC) $(CFLAGS) $< -o $@ -fno-stack-protector -U_FORTIFY_SOURCE -fno-omit-frame-pointer

fstack-protector: fstack-protector.c
	$(CC) $(CFLAGS) $< -o $@ -fstack-protector -U_FORTIFY_SOURCE -fno-omit-frame-pointer

unfortified: fortify.c
	$(CC) $(CFLAGS) $< -o $@ -fno-stack-protector -U_FORTIFY_SOURCE -fno-omit-frame-pointer

fortified: fortify.c
	$(CC) $(CFLAGS) $< -o $@ -fno-stack-protector -D_FORTIFY_SOURCE=2 -fno-omit-frame-pointer

fomit-frame-pointer: framepointer.c
	$(CC) $(CFLAGS) $< -o $@ -fomit-frame-pointer

fno-omit-frame-pointer: framepointer.c
	$(CC) $(CFLAGS) $< -o $@ -fno-omit-frame-pointer

alloca: alloca.c
	$(CC) $(CFLAGS) $< -o $@ -fno-omit-frame-pointer

clean:
	rm $(TARGETS)


