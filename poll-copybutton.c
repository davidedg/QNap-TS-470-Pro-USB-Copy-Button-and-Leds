// This is just to test the USB copy button status can be read (after initializing the HAL layer)
// CREDIT: https://gist.github.com/zopieux/0b38fe1c3cd49039c98d5612ca84a045#file-sio_read_write-c
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/io.h>

#define BASEPORT 0xa05
#define NPORTS 2

#define COPY_BUTTON   0xe2
#define COPY_BUTTON_B (1 << 2)

int main() {
  if (ioperm(BASEPORT, NPORTS, 1)) { perror("ioperm"); return(1); }

  // Poll USB COPY button
  outb(COPY_BUTTON, BASEPORT);
  while (1) {
    int value = inb(BASEPORT + 1) & COPY_BUTTON_B;
    printf("COPY button: %s\n", value ? "released" : "pressed");
    usleep(100000);
  }
  if (ioperm(BASEPORT, NPORTS, 0)) { perror("ioperm"); return(1); }
}
