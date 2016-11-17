kernel := build/kernel.bin
iso := build/ros.iso

linker_script := src/linker.ld
grub_cfg := src/grub.cfg
asm_src := $(wildcard src/*.asm)
o_files := $(patsubst src/%.asm,build/%.o,$(asm_src))

.PHONY: all clean iso

all:
	docker-compose up make

clean:
	rm -fr build

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
	mkdir -p build/isofiles/boot/grub
	cp $(kernel) build/isofiles/boot/kernel.bin
	cp $(grub_cfg) build/isofiles/boot/grub/
	grub-mkrescue -o $(iso) build/isofiles
	rm -r build/isofiles

$(kernel): $(o_files) $(linker_script)
	ld -n -T $(linker_script) -o $(kernel) $(o_files)

build/%.o: src/%.asm
	mkdir -p $(shell dirname $@)
	nasm -felf64 $< -o $@
