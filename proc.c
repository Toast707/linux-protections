#include <stdlib.h>

void proc() {
        char *buf = alloca(0x100);
        /* Don't allow gcc to optimize away the buf */
        asm volatile("" :: "m" (buf));
}
