.define __brk
.define __sbrk
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.extern __brk
.sect .text
__brk:
tst.b -40(sp)
link	a6,#-0
move.l 8(a6),-(sp)
jsr __Sbrk
add.l #4,sp
unlk a6
rts
.extern __sbrk
__sbrk:
tst.b -40(sp)
link	a6,#-0
move.w 8(a6), d2
ext.l d2
move.l d2,-(sp)
jsr __Ssbrk
add.l #4,sp
unlk a6
rts
__Ssbrk:		tst.b	-8(sp)
			move.l	4(sp),d0
			beq	1f
			add.l	.limhp,d0
			move.l	d0,-(sp)
			clr.l	-(sp)
			trap #0
.data2	0x11
			add.l	#8,sp
			bcc	1f
			jmp	cerror
1:
			move.l	.limhp,d0
			move.l	4(sp),d1
			add.l	d1,.limhp
			rts
__Sbrk:			trap #0
.data2	0x11
			bcc	1f
			jmp	cerror
1:
			move.l	4(sp),.limhp
			clr.l	d0
			rts
