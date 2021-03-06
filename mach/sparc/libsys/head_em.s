.global lino,filn
.global EXIT
.global	begtext,begdata,begbss
.global	EARRAY,ERANGE,ESET,EIDIVZ,EHEAP,EILLINS,ECASE,EBADGTO
.global	hol0,reghp,limhp,trpim,trppc

! runtime startof for sparc on sun4


LINO_AD	= 0
FILN_AD	= 4

EARRAY	= 0
ERANGE	= 1
ESET	= 2
EIDIVZ	= 6
EHEAP	= 17
EILLINS	= 18
ECASE	= 20
EBADGTO = 27

	.seg "text"

begtext:
	clr	%fp
        ld	[%sp + 0x40], %o0
	add	%sp, 0x44, %o1
	sll	%o0, 0x2, %o2
	add	%o2, 0x4, %o2
	add	%o1, %o2, %o2
	set	-0x100000, %g4		! should be a few M
	clr	%l1
	mov	%sp, %l0
	add	%sp, %g4, %sp
	dec	12, %l0
					! enable divide by 0 trap and improper
					! trap
	st	%fsr, [%l0]
	ld	[%l0], %o3
	set	0x09000000, %o4
	or	%o3, %o4, %o3
	st	%o3, [%l0]
	ld	[%l0], %fsr

	st	%o0, [%l0]
	st	%o1, [%l0+4]
	st	%o2, [%l0+8]

	call	__m_a_i_n
	nop
	dec	4, %l0
	st	%g0, [%l0]
EXIT:
	call	__exit
	nop

	.seg "data"
begdata:
	.word 0		! may be at virtual address 0 with no problem
hol0:
lino:
	.word	0	! lino
filn:
	.word	0	! filn
reghp:
	.word	__end
limhp:
	.word	__end
trppc:
	.word	0
trpim:
	.word	0	! USED TO BE 2 BYTES; IS THIS RIGHT?


	.seg "bss"
begbss: !initialization is not needed because ALL entries are in zero space!
