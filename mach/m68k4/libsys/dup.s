.define _dup
.extern _dup
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
_dup:		move.w #0x29,d0
		move.l 4(sp),a0
		jmp call
