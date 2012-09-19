//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
//
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


#ifndef COMMENT_SIMPLE_H
#define COMMENT_SIMPLE_H


#include <stdio.h>


#include "neurospaces/pidinstack.h"


/// \struct structure declarations

struct symtab_CommentSimple;


#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"



struct symtab_CommentSimple * CommentSimpleCalloc(void);

int
CommentSimpleCollectMandatoryParameterValues
(struct symtab_CommentSimple *pcomms, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
CommentSimpleCreateAlias
(struct symtab_CommentSimple *pcomms,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void CommentSimpleInit(struct symtab_CommentSimple *pcomms);


#include "neurospaces/hines_list.h"


/// \struct struct symtab_CommentSimple

struct symtab_CommentSimple
{
    /// base symbol

    struct symtab_HSolveListElement hsle;

    /// comment text

    char *pcCommentText;
};


#endif


