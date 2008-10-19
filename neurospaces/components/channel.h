//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: channel.h 1.23.1.52 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef CHANNEL_H
#define CHANNEL_H


#include <stdio.h>


#include "neurospaces/pidinstack.h"

#include "neurospaces/genesis/olf/olf_struct.h"


//s structure declarations

struct descr_Channel;
struct symtab_Channel;


#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"


//f exported functions

struct symtab_Channel * ChannelCalloc(void);

struct symtab_HSolveListElement * 
ChannelCreateAlias
(struct symtab_Channel *pchan,
 struct symtab_IdentifierIndex *pidin);

struct symtab_HSolveListElement *
ChannelGetEquation
(struct symtab_Channel *pchan, struct PidinStack *ppist);

struct descr_genesis_object *
ChannelGetGenesisObject(struct symtab_Channel *pchan);

struct symtab_HSolveListElement *
ChannelGetIncomingVirtual
(struct symtab_Channel *pchan, struct PidinStack *ppist);

struct symtab_Parameters * 
ChannelGetParameter
(struct symtab_Channel *pchan,
 struct PidinStack *ppist,
 char *pcName);

int ChannelHasEquation
(struct symtab_Channel *pchan, struct PidinStack *ppist);

int
ChannelHasMGBlockGMAX
(struct symtab_Channel *pchan, struct PidinStack *ppist);

int ChannelHasNernstErev
(struct symtab_Channel *pchan, struct PidinStack *ppist);

void ChannelInit(struct symtab_Channel *pchan);

double
ChannelParameterScaleValue
(struct symtab_Channel *pchan,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar);

int ChannelReceivesSpikes
(struct symtab_Channel *pchan, struct PidinStack *ppist);

int
ChannelSetTableParameters
(struct symtab_Channel *pchan, struct ParserContext *pac,char *pcFilename);

int ChannelSetup(struct symtab_Channel *pchan, struct ParserContext *pac);


#include "biocomp.h"
#include "equation.h"
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"


//s
//s link with genesis style object
//s

struct descr_genesis_object
{
    int iType;
    union
    {
	struct neurospaces_tab_channel_type *tabchan;
	struct neurospaces_tab2channel_type *tab2chan;
	struct neurospaces_tab_current_type *tabcurr;
    }
    uElement;
};

//s
//s channel description
//s

struct descr_Channel
{
    //m type of channel data

    int iType;

/*     //m list of hardcoded equations */

/*     HSolveList hslEquations; */

/*     //m list of hardcoded attachment points */

/*     HSolveList hslVirtuals; */

    //m file with table describing channel

    char *pcFilename;

    //m link with genesis style object

    struct descr_genesis_object genObject;
};


//s
//s struct symtab_Channel
//s

struct symtab_Channel
{
    //m base struct : bio component

    struct symtab_BioComponent bio;

    //m channel description

    struct descr_Channel dechan;
};


//d equation type

#define TYPE_CHANNEL_EQUATION		1

//d table in file

#define TYPE_CHANNEL_TABLEFILE		2

//d attachment point data

#define TYPE_CHANNEL_VIRTUALCONNECTION	4

//d additional channel parameters

#define TYPE_CHANNEL_PARAMETERS		5


#endif


