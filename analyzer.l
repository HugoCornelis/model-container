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
//' Copyright (C) 1999-2008 Hugo Cornelis
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

%x START_PCOMMENT
%x START_CCOMMENT

string  \"[^\0\\\"]*\"
bstring \"[^\0\\\"]*

digit		[0-9]
identifier	[a-z][a-z0-9_]*("["[0-9]+("-"[0-9]+)?"]"("["[0-9]+("-"[0-9]+)"]")*)?
ppcommentstart	"//"
commentstart	"/*"
commentend	"*/"


%%


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

^"#!".*			{	return(TOKEN_SHEBANGER);	}
<*>[ \t]+		/* eat up whitespace 		*/
\n			((PARSERCONTEXT *)pacParserContext)->iLineNumber++;

<*>"("			{	return('(');			}
<*>")"			{	return(')');			}
chantablefile		{	return(TOKEN_TABLEFILE);	}


absolute		{	return(TOKEN_ABSOLUTE);	}
algorithm		{	return(TOKEN_ALGORITHM);	}
alias		{	return(TOKEN_ALIAS);	}
alpha_equation		{	return(TOKEN_ALPHA_EQUATION);	}
attachment		{	return(TOKEN_ATTACHMENT);	}
attributes		{	return(TOKEN_ATTRIBUTES);	}
axon_hillock		{	return(TOKEN_AXON_HILLOCK);	}
bindables		{	return(TOKEN_BINDABLES);	}
bindings		{	return(TOKEN_BINDINGS);	}
cell		{	return(TOKEN_CELL);	}
channel		{	return(TOKEN_CHANNEL);	}
child		{	return(TOKEN_CHILD);	}
concentration_gate_kinetic		{	return(TOKEN_CONCENTRATION_GATE_KINETIC);	}
connection		{	return(TOKEN_CONNECTION);	}
connection_group		{	return(TOKEN_CONNECTION_GROUP);	}
contour_group		{	return(TOKEN_CONTOUR_GROUP);	}
contour_point		{	return(TOKEN_CONTOUR_POINT);	}
"."		{	return(TOKEN_CURRENT_SYMBOL);	}
cylindrical		{	return(TOKEN_CYLINDRICAL);	}
"->"		{	return(TOKEN_DEREFERENCE);	}
em_contour		{	return(TOKEN_EM_CONTOUR);	}
end		{	return(TOKEN_END);	}
equation_exponential		{	return(TOKEN_EQUATION_EXPONENTIAL);	}
events		{	return(TOKEN_EVENTS);	}
fiber		{	return(TOKEN_FIBER);	}
file		{	return(TOKEN_FILE);	}
gate_kinetic_a		{	return(TOKEN_GATE_KINETIC_A);	}
gate_kinetic_b		{	return(TOKEN_GATE_KINETIC_B);	}
gate_kinetic_part		{	return(TOKEN_GATE_KINETIC_PART);	}
generates		{	return(TOKEN_GENERATES);	}
group		{	return(TOKEN_GROUP);	}
grouped_parameters		{	return(TOKEN_GROUPED_PARAMETERS);	}
has		{	return(TOKEN_HAS);	}
hh_gate		{	return(TOKEN_HH_GATE);	}
"/"		{	return(TOKEN_HIERARCHICALSEPERATOR);	}
import		{	return(TOKEN_IMPORT);	}
input		{	return(TOKEN_INPUT);	}
"@"		{	return(TOKEN_IOSELECT);	}
meters		{	return(TOKEN_METERS);	}
"::"		{	return(TOKEN_NAMESPACESEPERATOR);	}
ncd		{	return(TOKEN_NCD);	}
ndf		{	return(TOKEN_NDF);	}
ned		{	return(TOKEN_NED);	}
network		{	return(TOKEN_NETWORK);	}
neuron		{	return(TOKEN_NEURON);	}
neurospaces		{	return(TOKEN_NEUROSPACES);	}
nmd		{	return(TOKEN_NMD);	}
nnd		{	return(TOKEN_NND);	}
options		{	return(TOKEN_OPTIONS);	}
output		{	return(TOKEN_OUTPUT);	}
parameter		{	return(TOKEN_PARAMETER);	}
parameters		{	return(TOKEN_PARAMETERS);	}
".."		{	return(TOKEN_PARENT_SYMBOL);	}
"^"		{	return(TOKEN_PARENT_SYMBOL);	}
pool		{	return(TOKEN_POOL);	}
population		{	return(TOKEN_POPULATION);	}
private_models		{	return(TOKEN_PRIVATE_MODELS);	}
projection		{	return(TOKEN_PROJECTION);	}
public_models		{	return(TOKEN_PUBLIC_MODELS);	}
randomvalue		{	return(TOKEN_RANDOMVALUE);	}
receives		{	return(TOKEN_RECEIVES);	}
relative		{	return(TOKEN_RELATIVE);	}
seconds		{	return(TOKEN_SECONDS);	}
segment		{	return(TOKEN_SEGMENT);	}
segment_group		{	return(TOKEN_SEGMENT_GROUP);	}
siemens		{	return(TOKEN_SIEMENS);	}
spherical		{	return(TOKEN_SPHERICAL);	}
units		{	return(TOKEN_UNITS);	}
version		{	return(TOKEN_VERSION);	}
voltage		{	return(TOKEN_VOLTAGE);	}

{identifier}		{
				//- store matched identifier

				lvalp->pcIdentifier 
				    = (char *)malloc(1 + yyleng);

				strncpy(lvalp->pcIdentifier,yytext,yyleng);

				lvalp->pcIdentifier[yyleng] = '\0';

				return(TOKEN_IDENTIFIER);
			}
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
