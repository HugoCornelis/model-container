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


//d
//d test type(patta) == struct symtab_Attachment * at compile time
//d

#define CompileTimeTestAttachment(patta)					\
do {									\
    struct symtab_Attachment atta;						\
    (patta) == &atta;							\
} while (0)


//d
//d check if attachment is incoming
//d

#define AttachmentPointIsIncoming(patta)					\
({									\
    CompileTimeTestAttachment(patta);					\
    AttachmentGetType(patta) == TYPE_ATTACHMENT_INCOMING;			\
})


//d
//d check if attachment is outgoing
//d

#define AttachmentPointIsOutgoing(patta)					\
({									\
    CompileTimeTestAttachment(patta);					\
    !AttachmentPointIsIncoming(patta);						\
})


//d
//d set datatype of attachment
//d

#define AttachmentSetDataType(patta,pc)					\
do {									\
    CompileTimeTestAttachment(patta);					\
    (patta)->deatta.pcDataType = pc;					\
} while (0)


#include "idin.h"


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
#include "inputoutput.h"
#include "parameters.h"
#include "symboltable.h"


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


#endif


