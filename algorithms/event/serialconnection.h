//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialconnection.h 1.12 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


/*
** algorithm structures
*/

#ifndef ALGORITHM_SERIALCONNECTION_H
#define ALGORITHM_SERIALCONNECTION_H


//s
//s connection array entry
//s

struct SymbolSerialConnection
{
    //m connection symbol

    struct symtab_Connection *pconn;
};


//s serial connection struct

struct SerialConnectionVariables
{
    //m number of serialized created connections

    int iConnectionsCreated;

    //m number of serialized added connections

    int iConnectionsAdded;

    //m array of all connections

    struct SymbolSerialConnection *psymserconn;
};


//v serial connection array

extern struct SerialConnectionVariables serconnVariables;


extern struct symtab_Algorithm *palgSerialConnection;


#endif


