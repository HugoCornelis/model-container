//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: modelevent.h 1.27 Wed, 28 Feb 2007 17:10:54 -0600 hugo $
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


/*
** model event interface
*/

#ifndef MODELEVENT_H
#define MODELEVENT_H


#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif


/// \def
/// \def event bit classification
/// \def

/// \def event type offset, #bits

#define EVENT_OFFSET_TYPES			((unsigned int)24)
#define EVENT_BITS_TYPES			((unsigned int)8)


/// \def event flag offset, #bits

#define EVENT_OFFSET_FLAGS			((unsigned int)0)
#define EVENT_BITS_FLAGS			((unsigned int)8)


/// \def event action offset, #bits

#define EVENT_OFFSET_ACTIONS			((unsigned int)8)
#define EVENT_BITS_ACTIONS			((unsigned int)8)


/// \def
/// \def all types of events (this should be an enumeration instead of flag)
/// \def

/// \def more than one component in this element
/// \def (e.g. prototype with multiple channels)

#define EVENT_TYPE_EXTENDED			((unsigned int)(1 << EVENT_OFFSET_TYPES))

/// \def element aliasing a model from the dependencies

#define EVENT_TYPE_DEPENDENT			((unsigned int)(2 << EVENT_OFFSET_TYPES))

/// \def pidin element

#define EVENT_TYPE_IDENTINDEX			((unsigned int)(3 << EVENT_OFFSET_TYPES))

/// \def equation element

#define EVENT_TYPE_EQUATION			((unsigned int)(4 << EVENT_OFFSET_TYPES))

/// \def channel element

#define EVENT_TYPE_CHANNEL			((unsigned int)(5 << EVENT_OFFSET_TYPES))

/// \def pool element

#define EVENT_TYPE_POOL				((unsigned int)(6 << EVENT_OFFSET_TYPES))

/// \def segment element

#define EVENT_TYPE_SEGMENT			((unsigned int)(7 << EVENT_OFFSET_TYPES))

/// \def single cell

#define EVENT_TYPE_CELL				((unsigned int)(8 << EVENT_OFFSET_TYPES))

/// \def cell population

#define EVENT_TYPE_POPULATION			((unsigned int)(9 << EVENT_OFFSET_TYPES))

/// \def single connection

#define EVENT_TYPE_CONNECTION			((unsigned int)(10 << EVENT_OFFSET_TYPES))

/// \def population to population projection

#define EVENT_TYPE_PROJECTION			((unsigned int)(11 << EVENT_OFFSET_TYPES))

/// \def network with populations/cells/projections/connections

#define EVENT_TYPE_NETWORK			((unsigned int)(12 << EVENT_OFFSET_TYPES))

/// \def attachment point

#define EVENT_TYPE_VIRTUAL			((unsigned int)(20 << EVENT_OFFSET_TYPES))


/// \def enumeration flag

#define EVENT_FLAG_ENUMERATION			((unsigned int)(1 << EVENT_OFFSET_FLAGS))

/// \def D3 position flag

#define EVENT_FLAG_D3POSITION			((unsigned int)(2 << EVENT_OFFSET_FLAGS))

/// \def main instantiated model

#define EVENT_FLAG_FINALMODEL			((unsigned int)(3 << EVENT_OFFSET_FLAGS))


/// \def event actions

/// \def start of parse

#define EVENT_ACTION_START			((unsigned int)1 << EVENT_OFFSET_ACTIONS)

/// \def finish of parse

#define EVENT_ACTION_FINISH			((unsigned int)2 << EVENT_OFFSET_ACTIONS)

/// \def creation of symbol (before add)

#define EVENT_ACTION_CREATE			((unsigned int)3 << EVENT_OFFSET_ACTIONS)

/// \def add of symbol

#define EVENT_ACTION_ADD			((unsigned int)4 << EVENT_OFFSET_ACTIONS)


/// \def all event types

#define EVENT_MASK_TYPES			((unsigned int)((1 << EVENT_BITS_TYPES) - 1) << EVENT_OFFSET_TYPES)


/// \def all event flags

#define EVENT_MASK_FLAGS			((unsigned int)((1 << EVENT_BITS_FLAGS) - 1) << EVENT_OFFSET_FLAGS)


/// \def all event actions

#define EVENT_MASK_ACTIONS			((unsigned int)((1 << EVENT_BITS_ACTIONS) - 1) << EVENT_OFFSET_ACTIONS)


/// \def
/// \def some convenience defines
/// \def

/// \def MULTIPLECOMPD3

#define EVENT_MULTIPLECOMPD3 ((unsigned int)(EVENT_TYPE_SEGMENT \
					     | EVENT_FLAG_ENUMERATION \
					     | EVENT_FLAG_D3POSITION))


#include "symboltable.h"


//f
//f

struct ParserEvent;
struct Symbols;
struct symtab_Algorithm;

typedef 
int ParserEventListener
    (struct ParserEvent *pev,
     struct symtab_Algorithm *palg);


#include "pidinstack.h"


/// \struct
/// \struct base event structure
/// \struct

typedef struct ParserEvent
{
    /// type of event

    int iType;

    /// type specific info

    union
    {
	/// pointer to related symbol table entry

	struct symtab_HSolveListElement *phsle;

	// pointer to specific symbol table info

	//union symtab_Element uSymbol;
    }
    uInfo;

    /// context element of event

    struct PidinStack pist;
}
ParserEvent;


/// \struct
/// \struct event listener associated with a particular event
/// \struct

typedef 
struct 
{
    /// event type

    int iParserEventType;

    /// function to process this event

    ParserEventListener *pfParserEventListener;

    /// \note probably more required
}
ParserEventAssociation;


/// \struct
/// \struct event association table
/// \struct

typedef
struct
{
    /// number of registrations

    int iParserEvents;

    /// event associations

    ParserEventAssociation *pevas;
}
ParserEventAssociationTable;


#include "algorithm.h"
#include "components/cell.h"
#include "components/channel.h"
#include "components/connection.h"
#include "components/network.h"
#include "components/population.h"
#include "components/projection.h"
#include "components/segment.h"
#include "pidinstack.h"


int ParserEventCellGenerate
(int iParserEvent,
 struct symtab_Cell *phsle, struct PidinStack *ppist);

int ParserEventSegmentGenerate
(int iParserEvent,
 struct symtab_Segment *phsle,
 struct PidinStack *ppist);

int ParserEventConnectionGenerate
(int iParserEvent,
 struct symtab_Connection *phsle,
 struct PidinStack *ppist);

int ParserEventNetworkGenerate
(int iParserEvent,
 struct symtab_Network *phsle,
 struct PidinStack *ppist);

int ParserEventPopulationGenerate
(int iParserEvent,
 struct symtab_Population *phsle,
 struct PidinStack *ppist);

int ParserEventProjectionGenerate
(int iParserEvent,
 struct symtab_Projection *phsle,
 struct PidinStack *ppist);

int ParserEventGenerate
(int iParserEvent,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);

int ParserEventInit(ParserEvent *pev);


#endif


