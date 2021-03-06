#include <ctype.h>
#include <system.h>
#include "em_decl.h"

/* This file contains the assemble routine that generates assembly code.
 * As 'str' is in assembly format this is a easy job. Only operands 
 * with "$n" in it need some special treatment. 
 * Note : a '$' is qouted by prefixing it with a '$'.
 */

assemble( str)
char *str;

/* Output assembly instruction. Substitute for '$n' the name of the
 * the n-th argument of the current EM-instruction.
 */
{
	char buf[512] , *b_ptr, *arg_format();
	int nr;

	b_ptr = buf;

	out( "fprint( codefile,\"");

	while ( *str) {
		switch  ( *str) {
		  case '$' :   if ( *(str+1) == '$') {
				        *b_ptr++ = '$';
					str = str + 2;
			       	}
			      	else {  
					nr = atoi( str+1) - 1;
					*b_ptr = '\0';
					out( "%s%s\", %s%s);", buf,
						   arg_format( nr),
						   C_instr_info->arg_type[nr] == ARITH ? "(long)" : "",
						   C_instr_info->arg_conv[nr]);
				        out( "fprint( codefile,\"");
					b_ptr = buf;
					str = str + 2;
				}
				break;
		  case '%':	*b_ptr++ = *str;
				/* fall through */
		  default  :    *b_ptr++ = *str++;
		}
	}

	*b_ptr = '\0';
	out( "%s\\n\");\n", buf);
}


char *arg_format( nr)
int nr;
{
	switch ( C_instr_info->arg_type[nr]) {
	  case ARITH : return( "%ld");
	  case STRING: return( "%s");
	  case INT   : return( "%d");
	}
	/*NOTREACHED*/
}
