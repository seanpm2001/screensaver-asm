PROJECT = screensaver
SRC = "$(PROJECT).asm"

AS = nasm
QEMU = qemu-system-i386

QEMU_FLAGS = -drive format=raw,index=0,media=disk,file="$(PROJECT).img"

default: 	build

build:		build_img build_com check_size

build_img:
			$(AS) -f bin -o "$(PROJECT).img" $(SRC)

build_com:
			$(AS) -f bin -l "$(PROJECT).lst" -o "$(PROJECT).com" -Dcom_file=1 $(SRC)

qemu:		build
			$(QEMU) $(QEMU_FLAGS)

check_size:
			stat --printf="size: %s byte(s)\n" "$(PROJECT).com"

clean:
			rm -f *.o *.lst *.elf *.img *.com *.bin

pong:
			nasm -f bin -o pong.bin pong.asm
			dd if=/dev/zero of=pong.img bs=1024 count=1440
			dd if=pong.bin of=pong.img seek=0 count=1 conv=notrunc
			qemu-system-i386 -drive format=raw,index=0,media=disk,file=pong.img
