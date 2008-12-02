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


/// \struct structure declarations

struct descr_Channel;
struct symtab_Channel;


#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"



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


/// \struct
/// \struct link with genesis style object
/// \struct

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

/// \struct
/// \struct channel description
/// \struct

struct descr_Channel
{
    /// type of channel data

    int iType;

/*     /// list of hardcoded equations */

/*     HSolveList hslEquations; */

/*     /// list of hardcoded attachment points */

/*     HSolveList hslVirtuals; */

    /// file with table describing channel

    char *pcFilename;

    /// link with genesis style object

    struct descr_genesis_object genObject;
};


/// \struct
/// \struct struct symtab_Channel
/// \struct

struct symtab_Channel
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// channel description

    struct descr_Channel dechan;
};


/// \def equation type

#define TYPE_CHANNEL_EQUATION		1

/// \def table in file

#define TYPE_CHANNEL_TABLEFILE		2

/// \def attachment point data

#define TYPE_CHANNEL_VIRTUALCONNECTION	4

/// \def additional channel parameters

#define TYPE_CHANNEL_PARAMETERS		5


#endif


