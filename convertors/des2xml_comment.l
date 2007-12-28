%{
//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: des2xml_comment.l 1.4 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#include "stdio.h"


%}

%option noyywrap
%option stack

%x START_PCOMMENT
%x START_CCOMMENT

%%

"{*"			{
				yy_push_state(START_PCOMMENT);
				fprintf(stdout,"<!-- PCOMMENT -->\n");
				fprintf(stdout,"<!-- \n{*");
			}
<START_PCOMMENT>{
	"{*"		{
				yy_push_state(START_PCOMMENT);
				fprintf(stdout,"{*");
			}
	"*}"		{
				/* the current state is not on the stack, so 
				** we first check what will be popped, before 
				** popping */
				if (yy_top_state() == START_PCOMMENT)
				{
					fprintf(stdout,"*}\n");
				}
				else
				{
					fprintf(stdout,"*}\n -->\n");
				}
				yy_pop_state();
			}
	[^\n]		{
				fprintf(stdout,"%s",yytext);
			}
	\n		{
				fprintf(stdout,"%s",yytext);
			}
}

"//"[^\n]*\n		{
				fprintf(stdout,"<!-- %s -->\n",yytext);
			}

"/*"			{
				yy_push_state(START_CCOMMENT);
				fprintf(stdout,"<!-- CCOMMENT -->\n");
				fprintf(stdout,"<!-- \n/*");
			}
<START_CCOMMENT>{
	"*/"		{
				yy_pop_state();
				fprintf(stdout,"*/\n -->\n");
			}
	[^\n]		{
				fprintf(stdout,"%s",yytext);
			}
	\n		{
				fprintf(stdout,"%s",yytext);
			}
}

