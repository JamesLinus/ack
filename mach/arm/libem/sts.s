.define	.sts

	.sect .text

.sts:	LDMFD R12<,{R0,R1,R2}
	CMP R0, #8
	BGE 2f
	CMP R0, #1
	STR.EQ.B R2,[R1]
	CMP R0, #4
	STR.EQ R2,[R1]
	CMP R0,#2
	MOV.NE R15,R14
	MOV R3,R2,LSR #8
	SUB R2,R2,R3,LSL #8
	STR.EQ.B R2,[R1]
	STR.EQ.B R3,[R1,#1]
	MOV R15,R14
2:
	ADD R3,R1,R0
1:
	STR R2,[R1]
	ADD R1,R1,#4
	CMP R1,R3
	MOV.EQ R15,R14
	LDMFD R12<,{R2}
	BAL 1b
