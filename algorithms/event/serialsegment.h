//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialsegment.h 1.19 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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
** algorithm structures
*/

#ifndef ALGORITHM_SERIALSEGMENT_H
#define ALGORITHM_SERIALSEGMENT_H


/// \struct
/// \struct segment array entry
/// \struct

struct SymbolSerialSegment
{
    /// segment symbol

    /// \structtruct symtab_HSolveListElement *phsle;

    struct symtab_Segment *psegment;

    /// parent segment, NULL for none

    struct SymbolSerialSegment *psymsersegmentParent;

    /// index of parent segment in this array, -1 for none

    int iParent;

    /// context of this segment

    /// \note I should try to resolve this in a different manner
    /// \note having a pist / segment is to much overhead

    struct PidinStack *ppist;
};


/// \struct serial segment struct

struct SerialSegmentVariables
{
    /// number of serialized created segments

    int iSegmentsCreated;

    /// number of serialized added segments

    int iSegmentsAdded;

    /// array of all segments

    struct SymbolSerialSegment *psymsersegment;
};


/// serial segment array

extern struct SerialSegmentVariables sersegmentVariables;


extern struct symtab_Algorithm *palgSerialSegment;



struct symtab_Segment *
SerialSegmentSetupStart
(struct SymbolSerialSegment *sersegment,
 struct PidinStack *ppist);

void SerialSegmentSetupEnd
(struct SymbolSerialSegment *sersegment,
 struct PidinStack *ppist);


#endif


