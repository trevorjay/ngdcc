# Put the filename of the output binary here
TARGET = ngdcc.elf

# List all of your C files here, but change the extension to ".o"
OBJS = ngdcc.o romdisk.o
KOS_ROMDISK_DIR = romdisk

KOS_LOCAL_CFLAGS = -I$(KOS_BASE)/addons/zlib
CFLAGS += -g -Wall -Wextra -ljpeg

all: rm-elf $(TARGET) mk-cdi

include $(KOS_BASE)/Makefile.rules

clean: rm-elf
	-rm -f $(OBJS)
	-rm -f romdisk.o romdisk.img
rm-elf:
	-rm -f $(TARGET)

$(TARGET): $(OBJS)
	kos-cc -o $(TARGET) $(OBJS) -ljpeg -lz

run: $(TARGET)
	$(KOS_LOADER) $(TARGET)

dist: $(TARGET)
	-rm -f $(OBJS)
	$(KOS_STRIP) $(TARGET)

.PHONY: mk-cdi
mk-cdi:
	mkdcdisc -a "montrose.is/games" -r 20240930 -e /opt/toolchains/dc/kos/examples/dreamcast/ngdcc/ngdcc.elf -d cds -d mlf -o /opt/toolchains/dc/kos/examples/dreamcast/ngdcc/ngdcc.cdi -n "NG DC Collab" -v
