.data
	a: .word 1
	b: .word 22
	c: .word 0

.text
.globl main
main:
	lw $t1, a
	lw $t2, b
	add $t0, $t1, $t2
	sw $t0, c
.end main