//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: attachment.h 1.27 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef ATTACHMENT_H
#define ATTACHMENT_H


//s structure declarations

struct descr_Attachment;
struct symtab_Attachment;


#include "neurospaces/idin.h"


//f exported functions

struct symtab_Attachment * AttachmentCalloc(void);

struct symtab_HSolveListElement * 
AttachmentCreateAlias
(struct symtab_Attachment *patta,
 struct symtab_IdentifierIndex *pidin);

int AttachmentGetType(struct symtab_Attachment *patta);

void AttachmentInit(struct symtab_Attachment *patta);

int AttachmentSetType(struct symtab_Attachment *patta, int iType);


#include "biocomp.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parameters.h"
#include "neurospaces/symboltable.h"


//s
//s attachment description
//s

struct descr_Attachment
{
    //m type of data that flows through the medium

    char *pcDataType;

    //m type of attachment data

    int iType;
};


//s
//s struct symtab_Attachment
//s

struct symtab_Attachment
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m candidate description

    struct descr_Attachment deatta;
};


//d incoming connection type

#define TYPE_ATTACHMENT_INCOMING		1

//d outgoing connection type

#define TYPE_ATTACHMENT_OUTGOING		2


//f exported inlines

#ifndef SWIG
static inline
#endif
int
AttachmentPointIsIncoming(struct symtab_Attachment *patta)
{
    return(AttachmentGetType(patta) == TYPE_ATTACHMENT_INCOMING);
}


#ifndef SWIG
static inline
#endif
int
AttachmentPointIsOutgoing(struct symtab_Attachment *patta)
{
    return(!AttachmentPointIsIncoming(patta));
}


#ifndef SWIG
static inline
#endif
int
AttachmentSetDataType(struct symtab_Attachment *patta, char *pc)
{
    patta->deatta.pcDataType = pc;

    return(1);
}


#endif


