//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: des2xml.c 1.5 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


#include <stdio.h>
#include <stdlib.h>


// argv[1] : description file
// argv[2] : xml file prefix

int main(int argc,char *argv[])
{
    char pc[10000];

    if (argv[2])
    {
	sprintf(pc,"/home/hugo/NeoSim/NeuroSpaces/source/c/0/convertors/des2xml.pl <%s | /home/hugo/NeoSim/NeuroSpaces/source/c/0/convertors/des2xml_comment >%s",argv[1],argv[2]);
    }
    else
    {
	sprintf(pc,"/home/hugo/NeoSim/NeuroSpaces/source/c/0/convertors/des2xml.pl <%s | /home/hugo/NeoSim/NeuroSpaces/source/c/0/convertors/des2xml_comment",argv[1]);
    }

    system(pc);

    exit(EXIT_SUCCESS);
}


