//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: lexsupport.c 1.13 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


/// \def This hack is based on
/// \def http://www.ethereal.com/lists/ethereal-dev/200307/msg00154.html
/// \def it is a work around for a bug in the API of current versions
/// \def of flex when using -P (if I got this wright).

#ifndef yy_delete_buffer
#define yy_delete_buffer parser_delete_buffer
#endif
#ifndef yy_create_buffer
#define yy_create_buffer parser_create_buffer
#endif
#ifndef yy_switch_to_buffer
#define yy_switch_to_buffer parser_switch_to_buffer
#endif

/*
** This file is included in the lexical analyzer...
** It uses macro's and buffers of the lexical analyzer.
*/

#include "neurospaces/lexsupport.h"


void LexAssociateRemove(struct yy_buffer_state **ppyyBuffer)
{
    /// \note *pyyBuffer should be same as YY_CURRENT_BUFFER

    //- remove lexical buffer

    yy_delete_buffer(*ppyyBuffer);
    *ppyyBuffer = NULL;
}


void LexAssociateWithParseContext(struct yy_buffer_state **ppyyBuffer)
{
    *ppyyBuffer = YY_CURRENT_BUFFER;
}


void LexFileSwitch(struct yy_buffer_state **ppyyBuffer,FILE *pFILE)
{
    //- create new lexical buffer for selected file

    *ppyyBuffer = yy_create_buffer(pFILE,YY_BUF_SIZE);

    //- make new buffer active

    yy_switch_to_buffer(*ppyyBuffer);

    //- push lexical initial state on lexical stack

    yy_push_state(INITIAL);
}


void LexFileUnswitch(struct yy_buffer_state *pyyBuffer)
{
    //- make given buffer active

    yy_switch_to_buffer(pyyBuffer);

    //- pop lexical state

    yy_pop_state();
}


