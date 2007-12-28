//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: namespace.h 1.14 Mon, 19 Mar 2007 17:08:38 -0500 hugo $
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
** namespace definitions, seperators and alike
*/

#ifndef NAMESPACE_H
#define NAMESPACE_H


//d define symbolic resolution of parent in symbol hierarchy

#define IDENTIFIER_SYMBOL_PARENT		..
#define IDENTIFIER_SYMBOL_PARENT_CHAR		'.' '.'
#define IDENTIFIER_SYMBOL_PARENT_STRING		".."


//d define symbolic resolution of current in symbol hierarchy

#define IDENTIFIER_SYMBOL_CURRENT		.
#define IDENTIFIER_SYMBOL_CURRENT_CHAR		'.'
#define IDENTIFIER_SYMBOL_CURRENT_STRING	"."


//d define symbolic resolution of name space in symbol hierarchy

#define IDENTIFIER_NAMESPACE			::
#define IDENTIFIER_NAMESPACE_CHAR		':' ':'
#define IDENTIFIER_NAMESPACE_STRING		"::"


//d define symbolic resolution of dereference to field in symbol hierarchy

#define IDENTIFIER_DEREFERENCE			->
#define IDENTIFIER_DEREFERENCE_CHAR		'-' '>'
#define IDENTIFIER_DEREFERENCE_STRING		"->"

//d define symbolic resolution of dereference to field in symbol hierarchy

#define IDENTIFIER_IOSELECT			@
#define IDENTIFIER_IOSELECT_CHAR		'@'
#define IDENTIFIER_IOSELECT_STRING		"@"

//d define symbolic resolution of child in symbol hierarchy

#define IDENTIFIER_CHILD			/
#define IDENTIFIER_CHILD_CHAR			'/'
#define IDENTIFIER_CHILD_STRING			"/"


// all legal seperators in a table of strings

/* extern char *ppcSeperators[]; */


//d root symbol

#define SYMBOL_ROOT			SYMBOL_CHAR_SEPERATOR


//d hierarchical symbol seperator

#define SYMBOL_CHAR_SEPERATOR		IDENTIFIER_CHILD_STRING


//d maximal depth of nested elements

#define MAX_ELEMENT_DEPTH		30


//f exported functions

int NameSpaceEndThisToken(char *pc);

int NameSpaceIsChildOperator(char *pc);

int NameSpaceIsChildToken(char *pc);

int NameSpaceIsNameSpaceOperator(char *pc);

int NameSpaceIsNameSpaceToken(char *pc);

int NameSpaceStartNextToken(char *pc);


#endif


