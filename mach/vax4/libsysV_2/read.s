.sect .text; .sect .rom; .sect .data; .sect .bss
.sect .text
read = 3
.define	_read

_read:
	.data2	0x0000
	chmk	$read
	bcc 	1f
	jmp 	cerror
1:
	ret
