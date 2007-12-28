//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: lexsupport.h 1.9 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#ifndef ANALYZER_H
#define ANALYZER_H

#include <stdio.h>

#include "parser.h"


struct yy_buffer_state;

int yylex(YYSTYPE *lvalp,void *pacParserContext);

void LexAssociateRemove(struct yy_buffer_state **ppyyBuffer);
void LexAssociateWithParseContext(struct yy_buffer_state **ppyyBuffer);
void LexFileSwitch(struct yy_buffer_state **ppyyBuffer,FILE *pFILE);
void LexFileUnswitch(struct yy_buffer_state *pyyBuffer);


#endif


