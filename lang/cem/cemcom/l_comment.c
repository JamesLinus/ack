/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */
/* $Header$ */
/*	Lint-specific comment handling	*/

#include	"lint.h"

#ifdef	LINT

#include	"arith.h"
#include	"l_state.h"

/*	Since the lexical analyser does a one-token look-ahead, pseudo-
	comments are read too soon.  This is remedied by first storing them
	in static variables and then moving them to the real variables
	one token later.
*/

static int notreached;
static int varargsN = -1;
static int argsused;
static check_pseudo();

int LINTLIB;				/* file is lint library */
int s_NOTREACHED;			/* statement not reached */
int f_VARARGSn;				/* function with variable # of args */
int f_ARGSUSED;				/* function does not use all args */

set_not_reached()
{
	notreached = 1;
}

move_NOT2s()
{
	s_NOTREACHED = notreached;
	notreached = 0;
}

set_varargs(n)
{
	varargsN = n;
}

move_VAR2f()
{
	f_VARARGSn = varargsN;
	varargsN = -1;
}

set_argsused(n)
{
	argsused = n;
}

move_ARG2f()
{
	f_ARGSUSED = argsused;
	argsused = 0;
}

set_lintlib()
{
	LINTLIB = 1;
}

#define IN_SPACE	0
#define IN_WORD		1
#define IN_COMMENT	2

lint_comment(c)
	int c;
{
/* This function is called with every character between /_* and *_/ (the
 * _underscores are used because comment in C doesn't nest).
 * It looks for pseudocomments.
 * In this version it is allowed that 'keyword' is followed by rubbish.
 * At the start of each comment the function should be initialized by
 * calling it with c = -2.
 * I am not sure if this way of information hiding is a good solution.
 */
	static int position;	/* IN_SPACE, IN_WORD, IN_COMMENT */
	static char buf[12];
	static int i;		/* next free position in buf */

	if (c == -2) {
		position = IN_SPACE;
		i = 0;
		return;
	}

	if (position == IN_COMMENT)
		return;

	if (position == IN_SPACE) {
		if (c == ' ' || c == '\t')
			return;
		position = IN_WORD;
	}
	/* position == IN_WORD */
	if (c == ' ' || c == '\t' || c == '*') {
		position = IN_COMMENT;
		check_pseudo(buf, i);
	}
	else
	if (i < 12)
		buf[i++] = (char)c;
	else
		position = IN_COMMENT;
}

#include	<ctype.h>

static
check_pseudo(buf, i)
	char *buf;
{
/* Look if the i characters in buf are aequivalent with one of the
 * strings N_OTREACHED, V_ARARGS[n], A_RGSUSED, L_INTLIBRARY
 * (the u_nderscores are there to not confuse (UNIX) lint)
 */
	buf[i++] = '\0';
	if (strcmp(buf, "NOTREACHED") == 0) {
		set_not_reached();
	}
	else if (strcmp(buf, "ARGSUSED") == 0) {
		set_argsused(1);
	}
	else if (strcmp(buf, "LINTLIBRARY") == 0) {
		set_lintlib();
	}
	else if (strncmp(buf, "VARARGS", 7) == 0) {
		if (i == 8) {
			set_varargs(0);
		}
		else if (i == 9 && isdigit(buf[7])) {
			set_varargs(atoi(&buf[7]));
		}
	}
}

#endif	LINT