%{
//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: analyzer.l 1.74 Fri, 14 Sep 2007 11:16:48 -0500 hugo $
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

#include <string.h>

#include "neurospaces/neurospaces.h"

// don't include it, it gives double typedef's of bison symbols

//#include "parser.h"
#include "neurospaces/lexsupport.h"
#include "neurospaces/parsersupport.h"


/*
** define the name of the scanning routine
*/

#define YY_DECL int parserlex(YYSTYPE *lvalp,void *pacParserContext)

#define ECHO 0

YY_DECL;

%}

%option noyywrap
%option stack

%x START_VERSION
%x START_PCOMMENT
%x START_CCOMMENT
/* %x START_ALGORITHM */

string  \"[^\0\\\"]*\"
bstring \"[^\0\\\"]*

digit		[0-9]
identifier	[a-z][a-z0-9_]*("["[0-9]+("-"[0-9]+)?"]"("["[0-9]+("-"[0-9]+)"]")*)?
ppcommentstart	"//"
commentstart	"/*"
commentend	"*/"


/* <START_ALGORITHM>{ */
/* 	algorithm		{ */
/* 				yy_pop_state(); */
/* 				return(TOKEN_ALGORITHM); */
/* 			} */
/* 	end		{	return(TOKEN_END);		} */
/* 	algorithm_instance	{	return(TOKEN_ALGORITHM_INSTANCE);	} */
/* 	{identifier}	{ */
/* 				//- store matched identifier */

/* 				lvalp->pcIdentifier  */
/* 				    = (char *)malloc(1 + yyleng); */

/* 				strncpy(lvalp->pcIdentifier,yytext,yyleng); */

/* 				lvalp->pcIdentifier[yyleng] = '\0'; */

/* 				return(TOKEN_IDENTIFIER); */
/* 			} */
/* 	{string}	{ */
/* 				lvalp->pstring */
/* 				  = (struct symtab_String *) */
/* 				    malloc */
/* 					(1 */
/* 					 + yyleng */
/* 					 + sizeof(struct symtab_String)); */

/* 				lvalp->pstring->pcString */
/* 				  = (char *)&lvalp->pstring[1]; */

/* 				strncpy */
/* 				  (lvalp->pstring->pcString,yytext,yyleng); */

/* 				lvalp->pstring->pcString[yyleng] = '\0'; */

/* 				lvalp->pstring->iLength = yyleng; */

/* 				return(TOKEN_STRING); */
/* 			} */
/* 	"{"[^}\n]*"}"	{ */
/* 				lvalp->pstring */
/* 				  = (struct symtab_String *) */
/* 				    malloc */
/* 					(1 */
/* 					 + yyleng */
/* 					 + sizeof(struct symtab_String)); */

/* 				lvalp->pstring->pcString */
/* 				  = (char *)&lvalp->pstring[1]; */

/* 				strncpy */
/* 				  (lvalp->pstring->pcString,yytext,yyleng); */

/* 				lvalp->pstring->pcString[yyleng] = '\0'; */

/* 				lvalp->pstring->iLength = yyleng; */

/* 				return(TOKEN_ALGORITHMPARAMETERS); */
/* 			} */
/* 	\n		{ */
/* 				((PARSERCONTEXT *)pacParserContext)->iLineNumber++; */
/* 			} */
/* } */


/* algorithm			{ */
/* 				yy_push_state(START_ALGORITHM); */
/* 				return(TOKEN_ALGORITHM); */
/* 			} */


%%

<START_VERSION>{
	input		{	return(TOKEN_INPUT);		}
	output		{	return(TOKEN_OUTPUT);		}
	{identifier}	{
				//- store matched identifier

				lvalp->pcIdentifier 
				    = (char *)malloc(1 + yyleng);

				strncpy(lvalp->pcIdentifier,yytext,yyleng);

				lvalp->pcIdentifier[yyleng] = '\0';

				return(TOKEN_IDENTIFIER);
			}
	{digit}+("."{digit}+)?	{
					/* *lvalp = atof(yytext); */
					yy_pop_state();
					return(TOKEN_VERSIONNUMBER);
				}
	{string}	{
				lvalp->pstring
				  = (struct symtab_String *)
				    malloc
					(1
					 + yyleng
					 + sizeof(struct symtab_String));

				lvalp->pstring->pcString
				  = (char *)&lvalp->pstring[1];

				strncpy
				  (lvalp->pstring->pcString,yytext,yyleng);

				lvalp->pstring->pcString[yyleng] = '\0';

				lvalp->pstring->iLength = yyleng;

				return(TOKEN_STRING);
			}
	\n		{
				((PARSERCONTEXT *)pacParserContext)->iLineNumber++;
			}
}

"{*"			yy_push_state(START_PCOMMENT);
<START_PCOMMENT>{
	"{*"		yy_push_state(START_PCOMMENT);
	"*}"		yy_pop_state();
	[^\n]		/*	eat everything		*/
	\n		{
				/* and count newlines		*/
				((PARSERCONTEXT *)pacParserContext)->iLineNumber++;
			}
}

"//"[^\n]*\n		{
				/* eat up C++ one-line comments	*/
				((PARSERCONTEXT *)pacParserContext)->iLineNumber++;
			}
"/*"			yy_push_state(START_CCOMMENT);
<START_CCOMMENT>{
	"*/"		yy_pop_state();
	[^\n]		/*	eat everything		*/
	\n		{
				/* and count newlines		*/
				((PARSERCONTEXT *)pacParserContext)->iLineNumber++;
			}
}

<*>[ \t]+		/* eat up whitespace 		*/
\n			((PARSERCONTEXT *)pacParserContext)->iLineNumber++;

neurospaces		{
/* 				yy_push_state(START_VERSION); */
				return(TOKEN_NEUROSPACES);
			}
ndf			{	return(TOKEN_NDF);		}
nnd			{	return(TOKEN_NND);		}
ncd			{	return(TOKEN_NCD);		}
nmd			{	return(TOKEN_NMD);		}
ned			{	return(TOKEN_NED);		}
version			{
/* 				yy_push_state(START_VERSION); */
				return(TOKEN_VERSION);
			}
units			{	return(TOKEN_UNITS);		}
seconds			{	return(TOKEN_SECONDS);	}
meters			{	return(TOKEN_METERS);		}
voltage			{	return(TOKEN_VOLTAGE);	}
siemens			{	return(TOKEN_SIEMENS);	}
import			{	return(TOKEN_IMPORT);	}
file			{
/* 				yy_push_state(START_VERSION); */
				return(TOKEN_FILE);
			}
chantablefile		{
/* 				yy_push_state(START_VERSION); */
				return(TOKEN_TABLEFILE);
			}
end			{	return(TOKEN_END);		}
public_models		{	return(TOKEN_PUBLIC_MODELS);	}
algorithm		{	return(TOKEN_ALGORITHM);	}
private_models		{	return(TOKEN_PRIVATE_MODELS);	}
fiber			{	return(TOKEN_FIBER);		}
group			{	return(TOKEN_GROUP);		}
has			{	return(TOKEN_HAS);		}
child			{	return(TOKEN_CHILD);		}
attachment_point	{	return(TOKEN_ATTACHMENT_POINT);	}
generates		{	return(TOKEN_GENERATES);	}
receives		{	return(TOKEN_RECEIVES);	}
events			{	return(TOKEN_EVENTS);		}
bindables		{	return(TOKEN_BINDABLES);	}
bindings		{	return(TOKEN_BINDINGS);		}
input			{	return(TOKEN_INPUT);		}
output			{	return(TOKEN_OUTPUT);		}
<*>"("			{	return('(');		}
<*>")"			{	return(')');		}
alias			{	return(TOKEN_ALIAS);		}
attributes		{	return(TOKEN_ATTRIBUTES);	}
parameter		{	return(TOKEN_PARAMETER);	}
parameters		{	return(TOKEN_PARAMETERS);	}
projection		{	return(TOKEN_PROJECTION);	}
gate_kinetic_b		{	return(TOKEN_GATE_KINETIC_B);	}
gate_kinetic_a		{	return(TOKEN_GATE_KINETIC_A);	}
gate_kinetic_part	{	return(TOKEN_GATE_KINETIC_PART);	}
em_contour		{	return(TOKEN_EM_CONTOUR);	}
concentration_gate_kinetic	{	return(TOKEN_CONCENTRATION_GATE_KINETIC);	}
hh_gate			{	return(TOKEN_HH_GATE);		}
contour_group		{	return(TOKEN_CONTOUR_GROUP);	}
contour_point		{	return(TOKEN_CONTOUR_POINT);	}
connection_group	{	return(TOKEN_CONNECTION_GROUP);	}
connection		{	return(TOKEN_CONNECTION);	}
network			{	return(TOKEN_NETWORK);		}
population		{	return(TOKEN_POPULATION);	}
cell			{	return(TOKEN_CELL);		}
neuron			{	return(TOKEN_NEURON);		}
randomvalue		{	return(TOKEN_RANDOMVALUE);	}
segment			{	return(TOKEN_SEGMENT);		}
segment_group		{	return(TOKEN_SEGMENT_GROUP);	}
channel			{	return(TOKEN_CHANNEL);		}
pool			{	return(TOKEN_POOL);		}
alpha_equation		{	return(TOKEN_ALPHA_EQUATION);	}
exp2_equation		{	return(TOKEN_EXP2_EQUATION);	}
options			{	return(TOKEN_OPTIONS);	}
spherical		{	return(TOKEN_SPHERICAL);	}
cylindrical		{	return(TOKEN_CYLINDRICAL);	}
absolute		{	return(TOKEN_ABSOLUTE);		}
relative		{	return(TOKEN_RELATIVE);		}
{identifier}		{
				//- store matched identifier

				lvalp->pcIdentifier 
				    = (char *)malloc(1 + yyleng);

				strncpy(lvalp->pcIdentifier,yytext,yyleng);

				lvalp->pcIdentifier[yyleng] = '\0';

				return(TOKEN_IDENTIFIER);
			}
"/"			{	return(TOKEN_HIERARCHICALSEPERATOR);	}
"::"			{	return(TOKEN_NAMESPACESEPERATOR);	}
"->"			{	return(TOKEN_DEREFERENCE);	}
"@"			{	return(TOKEN_IOSELECT);		}
"^"			{	return(TOKEN_PARENT_SYMBOL);	}
".."			{	return(TOKEN_PARENT_SYMBOL);	}
"."			{	return(TOKEN_CURRENT_SYMBOL);	}
"-"?{digit}+("."{digit}+)?("e"[-+]?{digit}+)?	{
							lvalp->dNumber = atof(yytext);
							return(TOKEN_NUMBER);
						}
{string}	{
			lvalp->pstring
			  = (struct symtab_String *)
			    malloc
				(1
				 + yyleng
				 + sizeof(struct symtab_String));

			lvalp->pstring->pcString
			  = (char *)&lvalp->pstring[1];

			strncpy(lvalp->pstring->pcString,yytext,yyleng);

			lvalp->pstring->pcString[yyleng] = '\0';

			lvalp->pstring->iLength = yyleng;

			return(TOKEN_STRING);
		}
<*>.			return(yytext[0]);


%%

/*
** included here so we can use the YY_* macro's,
** change start conditions etc.
*/

#include "lexsupport.c"
