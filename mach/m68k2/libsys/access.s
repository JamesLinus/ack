.define _access
.sect .text
.sect .rom
.sect .data
.sect .bss
.extern _access
.sect .text
_access:	move.w #0x21,d0
		move.l 4(sp),a0
		move.w 8(sp),d1
		ext.l  d1
		jmp callc
