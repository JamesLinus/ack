83300 #include "rundecs.h"
83310     (*  COPYRIGHT 1983 C.H.LINDSEY, UNIVERSITY OF MANCHESTER  *)
83320  (**)
83330 PROCEDURE CL68(PB: ASNAKED; RF: OBJECTP); EXTERN ;
83340 PROCEDURE GARBAGE (ANOBJECT: OBJECTP); EXTERN ;
83350 PROCEDURE FORMPDESC(OLDESC: OBJECTP; VAR PDESC1: PDESC); EXTERN ;
83360 FUNCTION NEXTEL(I: INTEGER; VAR PDESC1: PDESC): BOOLEAN; EXTERN ;
83370 PROCEDURE ERRORR(N :INTEGER); EXTERN ;
83380 FUNCTION CRSTRING(LENGTH: OFFSETRANGE): OBJECTP; EXTERN ;
83390 FUNCTION GETPROC(RN: OBJECTP): ASNAKED; EXTERN ;
83400 PROCEDURE TESTF(RF:OBJECTP;VAR F:OBJECTP); EXTERN;
83410 FUNCTION ENSLINE(RF:OBJECTP;VAR F:OBJECTP):BOOLEAN; EXTERN;
83420 PROCEDURE ENSSTATE(RF:OBJECTP;VAR F:OBJECTP;READING:STATUSSET); EXTERN;
83430 FUNCTION ENSPAGE(RF:OBJECTP;VAR F:OBJECTP):BOOLEAN; EXTERN;
83440 (**)
83450 PROCEDURE CLPASC1(P1: IPOINT; PROC: ASPROC); EXTERN;
83460 PROCEDURE CLPASC5(P1,P2 :IPOINT; P3,P4 :INTEGER; P5 :IPOINT; PROC: ASPROC); EXTERN;
83470 FUNCTION NXTBIT(VAR N: INTEGER): INTEGER; EXTERN;
83480 (**)
83490 (**)
83500 (*+01() (*$X6*) ()+01*) (*ONLY USED WITH PROC*)
83510 (*+01() FUNCTION TIMESTEN(T, E: INTEGER): REAL ; EXTERN ; ()+01*)
83520 (*+05() FUNCTION TIMESTEN( T: REAL; E: INTEGER ): REAL ; EXTERN ; ()+05*)
83530 (*+01() (*$X4*) ()+01*)
83540 (**)
83550 (**)
83560 FUNCTION SUBFIXED(SIGN,   (*0 OR 1 OR -1 FOR SPACE TO BE PROVIDED FOR SIGN*)
83570                   BEFORE, (*DIGITS (POSSIBLY SUPPRESSED) REQUIRED BEFORE DECIMAL POINT;
83580                             -VE MEANS AS MANY AS NECESSARY*)
83590                   POINT,  (*0 OR 1 FOR SPACE TO BE PROVIDED FOR DECIMAL POINT*)
83600                   AFTER  (*DIGITS AFTER DECIMAL POINT*)
83610                         : INTEGER;
83620               VAR EXP: INTEGER; (*TO RECEIVE DECIMAL EXPONENT IF EXPNEEDED*)
83630                   EXPNEEDED: BOOLEAN;
83640                   X: REALTEGER;
83650                   R: BOOLEAN; (*TRUE IF X IS REALLY .REAL*)
83660               VAR S: OBJECTP; (*NIL IF A NEW STRING IS TO BE CREATED;
83670                                 OTHERWISE, A STRING WHOSE CHARVEC IS TO RECEIVE THE RESULT
83680                                 (AND WHICH MUST BE LONG ENOUGH)*)
83690                   START: INTEGER (*FIRST INDEX OF S TO BE USED*)
83700                  ): BOOLEAN;
83710   LABEL 999;
83720   CONST POWOF2 = (*+01() 2000000000000000000B; (* 2^55 = 36028797018963968.0 *) ()+01*)
83730                          (*TWO TO THE POWER (NO. OF DIGITS IN MANTISSA)+7*)
83740                  (*+02() 1.0; ()+02*)
83750                  (*+05() 1.0; ()+05*)
83760         POWOF2OVER10 = (*+01() 146314631463146315B; (* ROUND( 2^55 / 10 ) = 3602879701896397.0 *) ()+01*)
83770                                (*CAREFULLY ROUNDED UP*)
83780                        (*+02() 0.1; ()+02*)
83790                        (*+05() 0.1; ()+05*)
83800 (*+44()  TYPE MINT = INTEGER; ()+44*)
83810   VAR L, M, BLANKS, PT, FIRSTDIG, INDEX: INTEGER;
83820   A, B, ROUNDD: MINT;
83830   PROCEDURE CONVR(Y(*>=0.0*): REAL; VAR L: INTEGER; VAR A: MINT);
83840   (*COMPUTES L = THE LARGEST NUMBER OF DIGITS BEFORE THE DECIMAL POINT (POSSIBLY NEGATIVE) WHICH MIGHT BE NEEDED;
83850              A = (Y*POWOF2)/10**L (ROUNDED TO NEAREST INTEGER?) *)
83860     (*+01() EXTERN; ()+01*)
83870 (*+05()
83880     CONST LOG10E = 0.43429; (*DELIBERATELY UNDERESTIMATED*)
83890     VAR LL: REAL;
83900       BEGIN
83910       LL :=LN(Y)*LOG10E;
83920       IF LL>0.0 THEN L := 1+TRUNC(LL)
83930       ELSE           L := TRUNC(LL);
83940       A := TIMESTEN(Y (* *POWOF2 *), -L);
83950       IF A >= 1.0 THEN
83960         BEGIN L := L+1; A := TIMESTEN(Y (* *POWOF2 *), -L) END;
83970       END ;
83980 ()+05*)
83990 (*+02()
84000     CONST LOG10E = 0.43429; (*DELIBERATELY UNDERESTIMATED*)
84010     VAR LL: REAL;
84020       BEGIN
84030       LL :=LN(Y)*LOG10E;
84040       IF LL>0.0 THEN L := 1+TRUNC(LL)
84050       ELSE           L := TRUNC(LL);
84060       A := (*-44() TIMESTE(Y (* *POWOF2 *), -L) ()-44*) (*+44() L ()+44*);
84070       IF A >= 1.0 THEN
84080         BEGIN L := L+1; A := (*-44() TIMESTE(Y (* *POWOF2 *), -L) ()-44*) (*+44() L ()+44*) END;
84090       END ;
84100 ()+02*)
84110   PROCEDURE CONVI(Y(*>=0*): INTEGER; VAR L: INTEGER; VAR A: MINT);
84120   (*AS CONVR, BUT FOR INTEGERS*)
84130     (*+01() EXTERN; ()+01*)
84140 (*+05()
84150     VAR I: INTEGER ; YY: INTEGER ;
84160       BEGIN
84170       YY := Y ;
84180       L := 0 ;
84190       WHILE YY >= 1 DO
84200         BEGIN L := L + 1 ; YY := YY DIV 10 END ;
84210       A := TIMESTEN(Y (* *POWOF2 *), -L)
84220       END ;
84230 ()+05*)
84240 (*+02()
84250     VAR I: INTEGER ; YY: INTEGER ;
84260       BEGIN
84270       YY := Y ;
84280       L := 0 ;
84290       WHILE YY >= 1 DO
84300         BEGIN L := L + 1 ; YY := YY DIV 10 END ;
84310 (*-44()      A := TIMESTE(Y (* *POWOF2 *), -L) ()-44*)
84320 (*+44()      A := Y; ()+44*)
84330       END ;
84340 ()+02*)
84350 (*-44()
84360   PROCEDURE ROUNDER(DIGITS: INTEGER; VAR ROUNDD: MINT);
84370   (* COMPUTES ROUNDD = 0.5 X ( 10 TO THE POWER OF - DIGITS ) X POWOF2 *)
84380     (*+01() EXTERN; ()+01*)
84390 (*+05()
84400     VAR I : INTEGER ;
84410       BEGIN
84420       IF DIGITS < 0 THEN DIGITS := 0 ELSE IF DIGITS > REALWIDTH THEN DIGITS := REALWIDTH ;
84430       ROUNDD := 1 ;
84440       FOR I := 1 TO DIGITS DO
84450         ROUNDD := ROUNDD / 10 ;
84460       (* ROUNDD = 10 TO THE POWER OF - DIGITS *)
84470       ROUNDD := 0.5 * ROUNDD (* *POWOF2 *);
84480       END ;
84490 ()+05*)
84500 (*+02()
84510     VAR I : INTEGER ;
84520       BEGIN
84530       IF DIGITS < 0 THEN DIGITS := 0 ELSE IF DIGITS > REALWIDTH THEN DIGITS := REALWIDTH ;
84540       ROUNDD := 1 ;
84550        FOR I := 1 TO DIGITS DO
84560          ROUNDD := ROUNDD / 10 ;
84570       (* ROUNDD = 10 TO THE POWER OF - DIGITS *)
84580       ROUNDD := 0.5 * ROUNDD (* *POWOF2 *);
84590       END ;
84600 ()+02*)
84610 ()-44*)
84620     BEGIN (* OF SUBFIXED *)
84630     WITH X DO
84640       BEGIN
84650        IF R THEN IF REA <> 0.0 THEN CONVR(ABS(REA), L, A) ELSE CONVI(ABS(INT), L, A)
84660        ELSE CONVI(ABS(INT), L, A);
84670 (*-44()
84680       IF EXPNEEDED THEN
84690         IF REA<>0.0 THEN
84700           BEGIN
84710             ROUNDER(BEFORE+AFTER, ROUNDD);
84720             B := A; A := A*10;
84730             IF A+ROUNDD<POWOF2 THEN
84740               BEGIN B := A; L := L-1 END;
84750             A := B+ROUNDD;
84760             EXP := L-BEFORE; L := BEFORE
84770             END
84780           ELSE
84790             BEGIN A := 0; EXP := 0 END 
84800         ELSE
84810           BEGIN
84820           ROUNDER(L+AFTER, ROUNDD);
84830           A := A+ROUNDD (*+01()+ORD(ROUNDD=0)()+01*);
84840           IF A<POWOF2OVER10 THEN
84850             BEGIN A := A*10; L := L-1 END
84860           END
84870 ()-44*)
84880       END ;
84890     IF L>0 THEN
84900       BEGIN IF BEFORE<0 THEN BEFORE := L; M := L END
84910     ELSE
84920       IF BEFORE<=0 THEN BEGIN BEFORE := ORD(POINT=0); M := BEFORE END ELSE M := 1;
84930     IF (L>BEFORE) OR (AFTER<0) THEN BEGIN SUBFIXED := FALSE; GOTO 999 END;
84940     IF S=NIL THEN S := CRSTRING(SIGN+BEFORE+POINT+AFTER);
84950     BLANKS := START-1+BEFORE-M+ORD(SIGN<0);
84960     WITH S^ DO
84970       BEGIN
84980       FOR INDEX := START TO BLANKS DO
84990         CHARVEC[INDEX] := ' ';
85000       IF SIGN=1 THEN
85010         BEGIN BLANKS := BLANKS+SIGN;
85020         IF (*-44() ( R AND ( X.REA < 0.0 ) ) OR ()-44*) 
85030            ( NOT R AND ( X.INT < 0 ) ) THEN
85040           CHARVEC[BLANKS] := '-' ELSE CHARVEC[BLANKS] := '+'
85050         END;
85060       PT := BLANKS+M+1; FIRSTDIG := START+BEFORE+SIGN-L+ORD(L<0);
85070 (*-44()
85080       FOR INDEX := BLANKS+1 TO BLANKS+M+POINT+AFTER DO
85090         IF INDEX=PT THEN CHARVEC[INDEX] := '.'
85100         ELSE IF INDEX<FIRSTDIG THEN CHARVEC[INDEX] := '0'
85110         ELSE
85120           BEGIN
85130           A := A*10;
85140 (*+01()
85150           CHARVEC[INDEX] := CHR( ORD( '0' ) + A DIV POWOF2 ) ;
85160           A := A MOD POWOF2
85170 ()+01*)
85180 (*-01()
85190           L := TRUNC( A (* / POWOF2 *));
85200           CHARVEC[INDEX] := CHR( ORD( '0' ) + L );
85210           A := A - L (* *POWOF2 *);
85220 ()-01*)
85230           END
85240 ()-44*)
85250 (*+44()
85260       FOR INDEX := BLANKS+M+POINT+AFTER DOWNTO BLANKS+1 DO
85270         IF INDEX=PT THEN CHARVEC[INDEX] := '.'
85280         ELSE IF INDEX<FIRSTDIG THEN CHARVEC[INDEX] := '0'
85290         ELSE
85300           BEGIN
85310           B := A MOD 10;
85320           A := A DIV 10;
85330           CHARVEC[INDEX] := CHR( ORD( '0' ) + B );
85340           END;
85350 ()+44*)
85360       END;
85370     SUBFIXED := TRUE;
85380 999:
85390     END;
85400 (**)
85410 (**)
85420 PROCEDURE ERRORFILL(VAR S: OBJECTP; LENGTH: INTEGER);
85430   VAR I: INTEGER;
85440     BEGIN
85450     IF S=NIL THEN S := CRSTRING(LENGTH);
85460     WITH S^ DO
85470       FOR I := 1 TO STRLENGTH DO CHARVEC[I] := ERRORCHAR
85480     END;
85490 (**)
85500 (**)
85510 PROCEDURE PUTT(RF: OBJECTP);
85520 (*+02() LABEL 1; ()+02*)
85530   VAR P: ^REALTEGER;
85540       TEMP: REALTEGER;
85550       PDESC1:PDESC;
85560       TEMPLATE:DPOINT;
85570       COUNT, XMODE, XSIZE, SIZE, I, J: INTEGER;
85580       F,PVAL:OBJECTP;
85590 (**)
85600 (*+02() PROCEDURE DUMMYP; (*JUST HERE TO MAKE 1 GLOBAL, NOT CALLED*)
85610         BEGIN GOTO 1 END;     ()+02*)
85620 (**)
85630   PROCEDURE ENSROOM(RF:OBJECTP;VAR F:OBJECTP;UPB:INTEGER);
85640     BEGIN IF [LINEOVERFLOW]<=F^.PCOVER^.STATUS
85650       THEN IF NOT ENSLINE(RF,F) THEN ERRORR(NOLOGICAL);
85660       WITH F^.PCOVER^ DO
85670         BEGIN IF COFCPOS+UPB-ORD(COFCPOS<=1)>CHARBOUND
85680           THEN BEGIN IF UPB>=CHARBOUND THEN ERRORR(SMALLLINE);
85690             STATUS:=STATUS+[LINEOVERFLOW];
85700             ENSROOM(RF,F,UPB)
85710             END
85720           ELSE IF COFCPOS<>1 THEN
85730             CLPASC5(ORD(F^.PCOVER), ORD(F), -1, ORD(' '), ORD(BOOK), DOPUTS);
85740         END    (*WITH*);
85750     END;  (*ENSROOM*)
85760   (**)
85770   PROCEDURE CRREALSTR(R:REAL;VAR S:OBJECTP;START:INTEGER);
85780     VAR E, F: REALTEGER;
85790         NOOK: BOOLEAN;
85800     BEGIN
85810       F.REA := R ;
85820       NOOK:=SUBFIXED(1,1,1,REALWIDTH-1,E.INT,TRUE,F,TRUE,S,START);
85830       S^.CHARVEC[START+REALWIDTH+2]:='E';
85840       NOOK:=SUBFIXED(1,EXPWIDTH,0,0,E.INT,FALSE,E,FALSE,S,START+REALWIDTH+3)
85850     END;
85860 (**)
85870   PROCEDURE VALUEPRINT(RF:OBJECTP;VAR F:OBJECTP);
85880     VAR D,I,J,EXP,UPB,LWB:INTEGER;
85890         S,STR :OBJECTP;
85900         NOOK:BOOLEAN;
85910     BEGIN WITH TEMP DO
85920       BEGIN
85930       UPB:=1;
85940       IF NOT([OPENED,WRITEMOOD,CHARMOOD]<=F^.PCOVER^.STATUS) THEN
85950         ENSSTATE(RF, F, [OPENED,WRITEMOOD,CHARMOOD]);
85960       XSIZE := SZINT;
85970       CASE XMODE OF
85980     -1:  (*FILLER*) XSIZE := 0;
85990 (*+61() 1,3,5: (*LONG MODES*)
86000           BEGIN XSIZE := SZLONG; DUMMY END; ()+61*)
86010      0:   (*INTEGER*)
86020           BEGIN UPB:=INTSPACE;
86030           ENSROOM(RF,F,UPB);
86040           NOOK:=SUBFIXED(1,INTWIDTH,0,0,EXP,FALSE,TEMP,FALSE,PUTSTRING,1);
86050         WITH F^.PCOVER^ DO CLPASC5(ORD(F^.PCOVER), ORD(PUTSTRING), 1, INTSPACE, ORD(BOOK), DOPUTS)
86060           END;
86070      2:   (*REAL*)
86080           BEGIN XSIZE := SZREAL; UPB:=REALSPACE;
86090           ENSROOM(RF,F,UPB);
86100           CRREALSTR(REA,PUTSTRING,1);
86110           WITH F^.PCOVER^ DO CLPASC5(ORD(F^.PCOVER), ORD(PUTSTRING), 1, UPB, ORD(BOOK), DOPUTS);
86120           END;
86130      4:   (*COMPL*)
86140           BEGIN UPB:=COMPLSPACE;
86150           ENSROOM(RF,F,UPB);
86160           REA := P^.REA;
86170           CRREALSTR(REA,PUTSTRING,1);
86180           PUTSTRING^.CHARVEC[REALSPACE+1]:=' ';
86190           PUTSTRING^.CHARVEC[REALSPACE+2]:='I';
86200           P:=INCPTR(P, SZREAL);  REA := P^.REA;
86210           CRREALSTR(REA,PUTSTRING,REALSPACE+3);
86220           WITH F^.PCOVER^ DO CLPASC5(ORD(F^.PCOVER), ORD(PUTSTRING), 1, UPB, ORD(BOOK), DOPUTS);
86230           END;
86240 7,9,10:   BEGIN LWB:=1;   (*STRING,BITS,BYTES*)
86250           IF XMODE=7 THEN
86260             BEGIN XSIZE := SZADDR; STR:=PTR; D:=STR^.STRLENGTH;
86270             IF [PAGEOVERFLOW]<=F^.PCOVER^.STATUS
86280             THEN IF NOT ENSPAGE(RF,F) THEN ERRORR(9999)
86290             END
86300           ELSE IF XMODE=9 THEN
86310             BEGIN J:=INT; (*BITS*)
86320             STR := CRSTRING(BITSWIDTH);
86330             WITH STR^ DO
86340             FOR I:=1 TO BITSWIDTH DO
86350               IF NXTBIT(J)=1 THEN CHARVEC[I]:='T' ELSE CHARVEC[I]:='F';
86360             D:=BITSWIDTH
86370             END
86380           ELSE IF XMODE=10     THEN  (*BYTES*)
86390             BEGIN STR := CRSTRING(BYTESWIDTH);
86400             WITH STR^ DO
86410             FOR I:=1 TO BYTESWIDTH DO CHARVEC[I]:=ALF[I];
86420             D:=BYTESWIDTH
86430             END;
86440           WHILE LWB<=D DO
86450             BEGIN IF [LINEOVERFLOW]<=F^.PCOVER^.STATUS
86460               THEN IF NOT ENSLINE(RF,F) THEN ERRORR(9999);
86470             WITH F^.PCOVER^ DO
86480               BEGIN UPB:=LWB+CHARBOUND-COFCPOS;  (*ROOM LEFT ON LINE*)
86490               IF UPB>D THEN UPB:=D;
86500               WITH F^.PCOVER^ DO CLPASC5(ORD(F^.PCOVER), ORD(STR), LWB, UPB, ORD(BOOK), DOPUTS);
86510               LWB:=UPB+1;
86520               END     (*WITH*)
86530             END;  (*OD*)
86540           IF XMODE IN [9,10] THEN GARBAGE(STR)
86550           END;    (*STRING*)
86560      6,8: (*CHAR, BOOL*)
86570           BEGIN
86580           IF LINEOVERFLOW IN F^.PCOVER^.STATUS THEN
86590             IF NOT ENSLINE(RF, F) THEN ERRORR(9999);
86600           IF XMODE=8 THEN (*BOOL*)
86610           IF (*+01()INT<0()+01*) (*-01()INT<>0()-01*) THEN
86620             INT := ORD('T') ELSE INT := ORD('F');
86630           IF (INT>=0) AND (INT<=MAXABSCHAR) THEN
86640             WITH F^.PCOVER^ DO CLPASC5(ORD(F^.PCOVER), ORD(S), -1, INT, ORD(BOOK), DOPUTS)
86650           ELSE ERRORR(RCHARERROR)
86660           END;
86670     11:   (*PROC*) CL68(GETPROC(PTR), RF);
86680     12:   (*STRUCT*)
86690           BEGIN J:=0;
86700           REPEAT J:=J+1 UNTIL TEMPLATE^[J]<0;
86710           I:=ORD(P);
86720           WHILE ORD(P)-I<TEMPLATE^[0] DO
86730             BEGIN J:=J+1;
86740             XMODE:=TEMPLATE^[J]-1;
86750             TEMP := P^ ;
86760             VALUEPRINT(RF,F);
86770             P:=INCPTR(P, XSIZE)
86780             END;
86790           XMODE:=12
86800           END;
86810     14:   (*CODE(REF FILE)VOID*)
86820           BEGIN
86830           XSIZE := SZPROC;
86840           CLPASC1(ORD(RF), PROCC);
86850           END;
86860         END; (*CASE*)
86870       END   (*WITH TEMP*);
86880     END;   (*VALUEPRINT*)
86890 (**)
86900     BEGIN    (*PUT*)
86910     (*PUTT IS CALLED FROM EITHER PUT OR PRINT, WHICH ARE WRITTEN
86920       IN ASSEMBLER. AT THIS POINT, STKTOP(0) CONTAINS COUNT, THE
86930       SPACE OCCUPIED BY DATA LIST ITEMS, BELOW THAT ARE PAIRS
86940       ON THE STACK, EACH CONSISTING OF AN XMODE AND A VALUE
86950     *)
86960 (*+02() 1: ()+02*) COUNT := GETSTKTOP(SZWORD, 0);
86970     FPINC(RF^);
86980     J := COUNT+SZWORD;
86990     WHILE J>SZWORD DO
87000       BEGIN
87010       J := J-SZWORD;
87020       XMODE := GETSTKTOP(SZWORD, J);
87030       CASE XMODE OF
87040       4,7,11,12,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31:
87050         BEGIN
87060         J := J-SZADDR;
87070         PVAL := ASPTR(GETSTKTOP(SZADDR, J));
87080         FPINC(PVAL^);
87090         END;
87100 (*+61() 1,3,5: J := J-SZLONG; ()+61*)
87110         14: J := J-SZPROC;
87120         2: J := J-SZREAL;
87130         0,6,8,9,10: J := J-SZINT;
87140         -1: (*NO ACTION*);
87150         END;
87160       END;
87170     TESTF(RF,F);
87180     J := COUNT+SZWORD;
87190     WHILE J>SZWORD DO
87200       BEGIN
87210       J := J-SZWORD;
87220       XMODE := GETSTKTOP(SZWORD, J);
87230       IF XMODE>=16 THEN (*ROW*)
87240         BEGIN
87250         J := J-SZADDR;
87260         XMODE:=XMODE-16;
87270         PVAL := ASPTR(GETSTKTOP(SZADDR, J));
87280         WITH PVAL^ DO
87290           BEGIN
87300           FORMPDESC(PVAL,PDESC1);
87310           TEMPLATE:=MDBLOCK;
87320           IF ORD(TEMPLATE)=0 THEN SIZE := SZADDR
87330           ELSE IF ORD(TEMPLATE)<=MAXSIZE THEN SIZE:=ORD(TEMPLATE)
87340           ELSE SIZE:=TEMPLATE^[0];
87350           WHILE NEXTEL(0,PDESC1) DO WITH PDESC1 DO WITH PDESCVEC[0] DO
87360             BEGIN I:=PP;
87370             WHILE I<PP+PSIZE DO
87380               BEGIN P:=INCPTR(PVALUE, I);
87390               TEMP := P^;
87400               VALUEPRINT(RF,F);
87410               I:=I+SIZE
87420               END
87430             END
87440           END
87450         END
87460       ELSE
87470         BEGIN
87480         CASE XMODE OF
87490           4,5,12: (*STRUCT, INCLUDING COMPL*)
87500             BEGIN
87510             J := J-SZADDR;
87520             PVAL := ASPTR(GETSTKTOP(SZADDR, J));
87530             TEMPLATE := PVAL^.DBLOCK;
87540             P := INCPTR(PVAL, STRUCTCONST);
87550             END;
87560           0,6,8,9,10:
87570             BEGIN J := J-SZINT; TEMP.INT := GETSTKTOP(SZINT, J) END;
87580 (*+61()
87590           1,3:
87600             BEGIN J := J-SZLONG; TEMP.LONG := GETSTKTOP(SZLONG, J) END;
87610 ()+61*)
87620           2:
87630             BEGIN J := J-SZREAL; (*-01()TEMP.REA()-01*)(*+01()TEMP.INT()+01*) := GETSTKTOP(SZREAL, J) END;
87640           7,11:
87650             BEGIN J := J-SZADDR; TEMP.PTR := ASPTR(GETSTKTOP(SZADDR, J)) END;
87660           14:
87670             BEGIN J := J-SZPROC; TEMP.PROCC := GETSTKTOP(SZPROC, J) END;
87680           -1: (*NO ACTION*);
87690           END;
87700         VALUEPRINT(RF, F);
87710         END;
87720       END;      (*OD*)
87730     J := COUNT+SZWORD;
87740     WHILE J>SZWORD DO
87750       BEGIN
87760       J := J-SZWORD;
87770       XMODE := GETSTKTOP(SZWORD, J);
87780       CASE XMODE OF
87790         4,7,11,12,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31:
87800           BEGIN
87810           J := J-SZADDR;
87820           PVAL := ASPTR(GETSTKTOP(SZADDR, J));
87830           WITH PVAL^ DO
87840             BEGIN FDEC; IF FTST THEN GARBAGE(PVAL) END;
87850           END;
87860 (*+61() 1,3,5: J := J-SZLONG; ()+61*)
87870         14: J := J-SZPROC;
87880         2: J := J-SZREAL;
87890         0,6,8,9,10: J := J-SZINT;
87900         -1: (*NO ACTION*);
87910         END;
87920       END;
87930     WITH RF^ DO
87940       BEGIN FDEC; IF FTST THEN GARBAGE(RF) END;
87950     END;    (* PUT *)
87960 (**)
87970 (**)
87980 (*-02()
87990 BEGIN (*OF A68*)
88000 END; (*OF A68*)
88010 ()-02*)
88020 (*+01()
88030 BEGIN (*OF MAIN PROGRAM*)
88040 END (* OF EVERYTHING *).
88050 ()+01*)
