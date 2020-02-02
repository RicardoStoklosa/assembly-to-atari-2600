all: cart.bin
	stella cart.bin

cart.bin: .FORCE
	dasm *.asm -f3 -v0 -ocart.bin

.FORCE:
