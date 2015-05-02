CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld.bfd
GDB=arm-none-eabi-gdb
OBJCOPY=arm-none-eabi-objcopy
CFLAGS=-march=armv7e-m -mcpu=cortex-m4 -mthumb -std=c99 -g

objs := boot/crt0.o src/blinky.o

run: boot.elf
	$(GDB) -x gdb_script.gdb boot.elf

boot.hex: boot.elf
	@echo "OBJCOPY $@"
	@$(OBJCOPY) -O ihex boot.elf boot.hex

boot.bin: boot.elf
	@echo "OBJCOPY $@"
	@$(OBJCOPY) -O binary boot.elf boot.bin

boot.elf: $(objs)
	@echo "LD      $@"
	@$(LD) -T boot/stm32f429_flash.ld $(objs) -o $@

%.o: %.c
	@echo "CC      $@"
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "CLEAN"
	@rm -f $(objs) boot.elf boot.bin boot.hex
