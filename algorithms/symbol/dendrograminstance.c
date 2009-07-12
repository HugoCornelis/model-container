//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
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


#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dendrogram.h"
#include "dendrograminstance.h"

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"


/// \struct dendrogram algorithm private data

/*s */
/*s struct with dendrogram options */
/*S */

struct DendrogramOptions_type
{
    /*m name of cell */

    char *pcCell;

    /*m filename of file to generate */

    char *pcFilename;
};

typedef struct DendrogramOptions_type DendrogramOptions;


/// \struct dendrogram variables

struct DendrogramVariables_type
{
    // cell we are generating a dendrogram for

    struct symtab_HSolveListElement *phsleCell;
    struct PidinStack *ppistCell;

    // number of segments in this cell

    int iSegments;

    // current segment

    int iCurrentSegment;

    // current RA

    int iCurrentRa;

    // variables from the dendrogram algorithm

#define MAXSIZE 10000

    struct dot_p{
	char name[80];
	char parent[80];
	double x;
	double y;
	double z;
	double d;
    } dp_arr[MAXSIZE];

    struct intermediate{
	double name[80];
	double parent[80];
	char type;
	double d;
	double len;
	double morph;
    } inter_arr[MAXSIZE];

    struct m_plot{
	double name[80];
	double parent[80];
	char type;  
	double x1;
	double y1;
	double x2;
	double y2;
	double morph;
	double d;
	int t_mark;
	int path;
    } m_arr[MAXSIZE];
  
    struct parm_disc{
	double val;
	int start;
    } RA_arr[100];  

    double Rm_arr[MAXSIZE];

};

typedef struct DendrogramVariables_type DendrogramVariables;


/// \struct Dendrogram instance, derives from algorithm instance

struct DendrogramInstance
{
    /// base struct

    struct AlgorithmInstance algi;

    /// options for this instance

    DendrogramOptions cco;

    /// variables for this instance

    DendrogramVariables ccv;
};


struct DendrogramInstance_data
{
    /// dendrogram algorithm instance

    struct DendrogramInstance *pcci;

};


struct DendrogramInstance_data *ppiacGlobal = NULL;


// local functions

static
int
DendrogramInstanceGenerator
(struct DendrogramInstance *pcci,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist);

static
int
DendrogramInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static
int
DendrogramSegmentProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static 
int
DendrogramInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);


/// 
/// \arg pcci dendrogram algorithm instance.
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Generate a dendrogram.
/// 

static
int
DendrogramInstanceGenerator
(struct DendrogramInstance *pcci,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    struct DendrogramInstance_data piac =
	{
	    /// dendrogram algorithm instance

	    pcci,

	};

    //- set global data

    ppiacGlobal = &piac;

    //- count segments

    pcci->ccv.iSegments = SymbolCountSegments(phsle, ppist);

    //- \allocate memory

    // \todo predefined size is used, see structs above

    piac.pcci->ccv.iCurrentSegment = 0;
    piac.pcci->ccv.iCurrentRa = 0;

    piac.pcci->ccv.RA_arr[piac.pcci->ccv.iCurrentRa].val = -1;

    //- loop over segments

    if (SymbolTraverseSegments
	(phsle,
	 ppist,
	 DendrogramSegmentProcessor,
	 NULL,
	 &piac) == 1)
    {
	//- set result : ok

	iResult = TRUE;
    }

    //- mark the end of the RA array

    piac.pcci->ccv.RA_arr[piac.pcci->ccv.iCurrentRa].start = -1;

    int convert_to_inter(int size);
    void convert_to_m(int T_num, int size);
    void write_file(char *file_name, int size);
    int calc_horiz(int size);

    convert_to_m(convert_to_inter(piac.pcci->ccv.iCurrentSegment), piac.pcci->ccv.iCurrentSegment); 

    int size = calc_horiz(piac.pcci->ccv.iCurrentSegment);

    write_file(pcci->cco.pcFilename, size); 

    //- erase global data

    ppiacGlobal = NULL;

    //- return result

    return(iResult);
}


/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of dendrogram
/// algorithm.
/// 

struct AlgorithmInstance *
DendrogramInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/dendrogram_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct DendrogramInstance *pcci
	= (struct DendrogramInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct DendrogramInstance), _vtable_dendrogram, HIERARCHY_TYPE_algorithm_instances_dendrogram);

    AlgorithmInstanceSetName(&pcci->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	//- scan cell name

	/// \todo should use ParameterResolveSymbol()

	struct symtab_Parameters *pparCell
	    = SymbolFindParameter(&palgs->hsle, ppist, "CELL_NAME");

	pcci->cco.pcCell = ParameterGetString(pparCell);

	//- scan output filename

	/// \todo should use ParameterResolveSymbol()

	struct symtab_Parameters *pparFilename
	    = SymbolFindParameter(&palgs->hsle, ppist, "FILENAME");

	pcci->cco.pcFilename = ParameterGetString(pparFilename);

    }

    //- set result

    palgiResult = &pcci->algi;

    //- return result

    return(palgiResult);
}


/// 
/// \arg pcci dendrogram instance.
/// 
/// \return int : success of operation
/// 
/// \brief Checks connection groups with connections in projection.
/// 

static
int
DendrogramSegmentProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to current connection group data

    struct DendrogramInstance_data *ppiac
	= (struct DendrogramInstance_data *)
	  pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle
	= (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    PidinStackString(ptstr->ppist, ppiac->pcci->ccv.dp_arr[ppiac->pcci->ccv.iCurrentSegment].name, 80);

    struct symtab_Parameters *pparParent
	= SymbolFindParameter(phsle, ptstr->ppist, "PARENT");

    if (pparParent)
    {
	struct PidinStack *ppistParent
	    = ParameterResolveToPidinStack(pparParent, ptstr->ppist);

	PidinStackString(ppistParent, ppiac->pcci->ccv.dp_arr[ppiac->pcci->ccv.iCurrentSegment].parent, 80);

/* SymbolParameterResolveCoordinateValue */
/* (struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistCoord, */
/*  struct D3Position *pD3Coord) */

	ppiac->pcci->ccv.dp_arr[ppiac->pcci->ccv.iCurrentSegment].x = SymbolParameterResolveValue(phsle, ptstr->ppist, "X");
	ppiac->pcci->ccv.dp_arr[ppiac->pcci->ccv.iCurrentSegment].y = SymbolParameterResolveValue(phsle, ptstr->ppist, "Y");
	ppiac->pcci->ccv.dp_arr[ppiac->pcci->ccv.iCurrentSegment].z = SymbolParameterResolveValue(phsle, ptstr->ppist, "Z");
	ppiac->pcci->ccv.dp_arr[ppiac->pcci->ccv.iCurrentSegment].d = SymbolParameterResolveValue(phsle, ptstr->ppist, "DIA");

	double dRa = SymbolParameterResolveValue(phsle, ptstr->ppist, "RA");

	if (dRa != ppiac->pcci->ccv.RA_arr[ppiac->pcci->ccv.iCurrentRa].val)
	{
	    ppiac->pcci->ccv.RA_arr[ppiac->pcci->ccv.iCurrentRa].val = dRa;

	    ppiac->pcci->ccv.RA_arr[ppiac->pcci->ccv.iCurrentRa].start = ppiac->pcci->ccv.iCurrentSegment;

	    ppiac->pcci->ccv.iCurrentRa++;
	}

	ppiac->pcci->ccv.Rm_arr[ppiac->pcci->ccv.iCurrentSegment] = SymbolParameterResolveValue(phsle, ptstr->ppist, "RM");

    }
    else
    {
	//t report failure
    }

    ppiac->pcci->ccv.iCurrentSegment++;

    //- return result

    return(iResult);
}


/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on dendrogram instance.
/// 

static
int
DendrogramInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to algorithm instance

    struct DendrogramInstance *pcci
	= (struct DendrogramInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&pcci->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: DendrogramInstance %s\n"
	 "report:\n"
	 "    something here: of course\n",
	 pcInstance);

    fprintf
	(pfile,
	 "    DendrogramInstance_projection: crazy world\n");

    //- return result

    return(bResult);
}


/// 
/// \arg AlgorithmInstanceSymbolHandler args.
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to generate a dendrogram.
/// 

static 
int
DendrogramInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- get pointer to algorithm instance

    struct DendrogramInstance *pcci
	= (struct DendrogramInstance *)palgi;

    //- if cell

    if (instanceof_cell(phsle))
    {
	//- register cell info

	pcci->ccv.phsleCell = phsle;
	pcci->ccv.ppistCell = ppist;

	//- generate the dendrogram

	if (DendrogramInstanceGenerator(pcci, phsle, ppist))
	{
	}
	else
	{
	    NeurospacesError
		(pac,
		 "DendrogramInstance",
		 "(%s) DendrogramInstanceGenerator failed for %s\n",
		 AlgorithmInstanceGetName(&pcci->algi),
		 "(no pidin)");
/* 	         SymbolName(phsle)); */
	}
    }

    //- else

    else
    {
	//- give diag's : not a cell

	NeurospacesError
	    (pac,
	     "DendrogramInstance",
	     "(%s) on non cell %s\n",
	     AlgorithmInstanceGetName(&pcci->algi),
	     "(no pidin)");
/* 	     SymbolName(phsle)); */
    }

    //- return result

    return(iResult);
}



#define dp_arr ppiacGlobal->pcci->ccv.dp_arr
#define m_arr ppiacGlobal->pcci->ccv.m_arr
#define inter_arr ppiacGlobal->pcci->ccv.inter_arr
#define RA_arr ppiacGlobal->pcci->ccv.RA_arr
#define Rm_arr ppiacGlobal->pcci->ccv.Rm_arr

int found_branch(char *name, int size);
int find_index(char *name);
int find_child(char *parent);
double round(double number);
int convert_to_inter(int size);
void calc_T_y(int index, int size);
int check_x(int size);
int *children_have_x(int index, int size);
double greatest_x(int *child_info);
double least_x(int *child_info);
void set_parent_x(int index);
void calc_B_x(int size);
int all_T_counted(int branch_index, int size);
int domain_T(char *branch_name, char *domain, int size);
int other_T(int branch_index, int size);
void calc_T_x(int index,double x_tab, int size);
int calc_horiz(int size);
void convert_to_m(int T_num, int size);
void write_file(char *file_name, int size);


/************************************************************************

			     found_branch

	  Determines whether or not compartment is a branch.

************************************************************************/

int found_branch(char *name, int size)
{
  int i;

  for(i=0;i<size;i++)
    if(!strcmp(name,dp_arr[i].parent))
      return(1);
  return(0);
}




/************************************************************************

			      find_index

	       Finds array index of parent compartment.

************************************************************************/

int find_index(char *name)
{
  int i;

  i=0;
  while(strcmp(m_arr[i].name,name))
    i++;
  return(i);
}



int find_child(char *parent)
{
  int i;

  i=0;
  while(strcmp(m_arr[i].parent,parent))
    i++;
  return(i);
}



/************************************************************************

                                round

************************************************************************/


double round(double number)
{
  number=number*1e+5;
/*   number=anint(number); */

  number = (int)(number + 0.5);
  number=number*1e-5;
  return(number);
}


/************************************************************************

			   convert_to_inter

  Converts array containing .p file into another array which includes
  a code designating each compartment as a branch (B), termination (T)
  or continuation (C) point.  Also calculates electrotonic length.
  Although this intermediate array is not really necessary, it makes
  debugging easier.

************************************************************************/

int convert_to_inter(int size)
{
  FILE *fp;
  int i, k, T_num, branch_index;

  if((fp=fopen("/tmp/test_file2","w"))==NULL){
    exit(0);
  }

  k=0;
  for(i=0;i<size;i++){
    if(i==0)
      inter_arr[i].len=sqrt(dp_arr[i].x*dp_arr[i].x+
			    dp_arr[i].y*dp_arr[i].y+
			    dp_arr[i].z*dp_arr[i].z);
    else{
      if(!strcmp(dp_arr[i].parent,"."))
	inter_arr[i].len=sqrt(pow(dp_arr[i].x-dp_arr[i-1].x,2.0)+
			      pow(dp_arr[i].y-dp_arr[i-1].y,2.0)+
			      pow(dp_arr[i].z-dp_arr[i-1].z,2.0));
      else{
	branch_index=0;
	while(strcmp(dp_arr[branch_index].name,dp_arr[i].parent))
	  branch_index++;
	inter_arr[i].len=sqrt(pow(dp_arr[i].x-dp_arr[branch_index].x,2.0)+
			      pow(dp_arr[i].y-dp_arr[branch_index].y,2.0)+
			      pow(dp_arr[i].z-dp_arr[branch_index].z,2.0));
      }
    }
    strcpy(inter_arr[i].name,dp_arr[i].name);
    strcpy(inter_arr[i].parent,dp_arr[i].parent);
    inter_arr[i].d=dp_arr[i].d;
    if(RA_arr[k+1].start>-1)
      if(i==RA_arr[k+1].start)
	k++;

    inter_arr[i].morph=(1.0e-06*inter_arr[i].len)/
      (round(sqrt((3.1415927e-18*inter_arr[i].len*
		   dp_arr[i].d
		   *dp_arr[i].d*Rm_arr[i])/
		  (RA_arr[k].val*4.0))));


/* printf("morph = %e  name = %s\n",inter_arr[i].morph,inter_arr[i].name); */

    
    T_num=0;
    if(i==size-1){
      inter_arr[i].type='T';
      T_num++;
    }
    else{
      if(found_branch(inter_arr[i].name,size))
	inter_arr[i].type='B';
      else{
	if(strcmp(dp_arr[i+1].parent,".")){
	  inter_arr[i].type='T';
	  T_num++;
	}
	else
	  inter_arr[i].type='C';
      }
    }
    


    
    fprintf(fp,"%s %s %c %.2f %.2f %e %d\n",inter_arr[i].name,
	   inter_arr[i].parent,inter_arr[i].type,inter_arr[i].d,
	   inter_arr[i].len,inter_arr[i].morph,i); 
    

  }
  
  
  fclose(fp);

  return(T_num);
}




/************************************************************************

			       calc_T_y

	   Calculates y coordinates of dendrogram segments.

************************************************************************/

void calc_T_y(int index, int size)
{
  int i,path_num,branch_flag,branch_index;
  double cum_morph;

  branch_flag=0;
  i=index;
  path_num=0;

  while(m_arr[i].y2==0.0000){
    branch_flag=0;
    path_num++;
    m_arr[i].path=path_num;
    if(i==0)
      break;
    if(!strcmp(m_arr[i].parent,".")){
      i--;
    }
    else
      if(strcmp(m_arr[i].parent,"none")){
	branch_index=find_index(m_arr[i].parent);
	if(m_arr[branch_index].y2==0.0000){
	  i=branch_index; 
	  path_num++;
	  m_arr[i].path=path_num;
	}
	else{
	  branch_flag=1; /* 1 */
	  break; 
	}
      }
  }

  if(branch_flag){
    if(m_arr[branch_index].y2>0.0000){
      cum_morph=m_arr[branch_index].y2;
    }
    else{
      cum_morph=m_arr[branch_index].morph;
    }
  }
  else{
    if(i>0)
      if(m_arr[i].y2>0.0000){
	cum_morph=m_arr[i].y2;
      }
      else{
	cum_morph=m_arr[i].morph;
      }
    else{
      cum_morph=m_arr[i].morph;
    }
  }


  i=0;
  do{
    if(m_arr[i].path!=0){
      m_arr[i].y1=cum_morph;
      cum_morph+=m_arr[i].morph;
      m_arr[i].y2=cum_morph;
      m_arr[i].path=0;
    }
    i++;
  }while(i<size);
}



/************************************************************************

			       check_x

  Checks to make sure that x values for all dendrogram segments have
  been calculated.

************************************************************************/

int check_x(int size)
{
  int i;

  i=1;
  while((i<size)&&(m_arr[i].x1>0.01))
    i++;
  if(i==size)
    return(0);
  else
    return(1);
}


/************************************************************************

			   children_have_x

Checks to see if children of comp[index] have x values.  If so, values
are loaded into an array which contains x values of children.

************************************************************************/

int *children_have_x(int index, int size)
{
  int i, child_info[100];

  if(m_arr[index+1].x1>0.0000){
    child_info[0]=1;
    child_info[1]=index+1;    
  }
  else
    return(NULL);

  i=0;    
  for(i=0;i<size;i++){
    if(!strcmp(m_arr[index].name,m_arr[i].parent)&&(m_arr[i].x1>0.0000)){
      child_info[0]++;
      child_info[child_info[0]]=i;
    }
  }

  if(child_info[0]<=1){
    return(NULL);
  }
  return(child_info);
}

     

/************************************************************************

			      greatest_x

	   Finds greatest x value among child compartments.

************************************************************************/

double greatest_x(int *child_info)
{
  int i;
  double greatest;

  for(i=1;i<child_info[0]+1;i++){
    if(i==1)
      greatest=m_arr[child_info[1]].x1;
    else
      if(greatest<m_arr[child_info[i]].x1)
	greatest=m_arr[child_info[i]].x1;
  }

  return(greatest);
}



/************************************************************************

			       least_x

	    Finds least x value among child compartments.

************************************************************************/

double least_x(int *child_info)
{
  int i;
  double least;

  for(i=1;i<child_info[0]+1;i++){
    if(i==1)
      least=m_arr[child_info[1]].x1;
    else
      if(least>m_arr[child_info[i]].x1)
	least=m_arr[child_info[i]].x1;
  }

  return(least);
}




/************************************************************************

			     set_parent_x

       Sets parents of T compartments to appropriate x values.

************************************************************************/

void set_parent_x(int index)
{
  int i;

  i=index-1;
  while((m_arr[i].type=='C')/*&&!strcmp(m_arr[i].parent,".")*/){
    m_arr[i].x1=m_arr[index].x1;
    m_arr[i].x2=m_arr[i].x1;
    if(!m_arr[i].t_mark)
      m_arr[i].t_mark=888;

    i--;

  }
}





/************************************************************************

			       calc_B_x

			Sets branch x values.

************************************************************************/

void calc_B_x(int size)
{
  int test,i,*child_info;
    
  i=0;
  test=check_x(size);

  while(check_x(size)&&(i<size)){

    if((m_arr[i].x1<0.01)&&(m_arr[i].type=='B')){
      if((child_info=children_have_x(i,size))!=NULL){
	m_arr[i].x1=(greatest_x(child_info)+least_x(child_info))/2.00;
	m_arr[i].x2=m_arr[i].x1;
	if(!m_arr[i].t_mark)
	  m_arr[i].t_mark=999;
	set_parent_x(i);
      }
    }
    i++;
  }
  
  if(check_x(size))
    calc_B_x(size); 
}      




/************************************************************************

			    all_T_counted

	    Makes sure that all T points have been found.

************************************************************************/

int all_T_counted(int branch_index, int size)
{
  int i,answer;
  
  i=0;
  answer=0;
  if(m_arr[branch_index+1].t_mark){
    answer=1;
    for(i=0;i<size;i++)
      if(!strcmp(m_arr[i].parent,m_arr[branch_index].name)&&!m_arr[i].t_mark)
	answer=0;
  }

  return(answer);
}




/************************************************************************

			       domain_T

    Makes sure that the next T chosen will be in the same domain if 
    possible.  Examples of domains: apical and basal portions of
    dendrites.

************************************************************************/

int domain_T(char *branch_name, char *domain, int size)
{
  int i,str_len;

  str_len=strlen(domain);
  for(i=0;i<size;i++)
    if(!strcmp(m_arr[i].parent,branch_name)&&
	!strncmp(m_arr[i].name,domain,str_len)&&!m_arr[i].t_mark)
    return(i);

    return(0);

}





/************************************************************************

			       other_T

    Looks for the other T point coming off of the present branch point.

************************************************************************/

int other_T(int branch_index, int size)
{
  int i,j,answer,temp,new_branch_index;
  
  answer=-999;

  if(!m_arr[branch_index+1].t_mark){
    if(!domain_T(m_arr[branch_index].name,"basal",size)){
      i=branch_index;
      while(m_arr[i].type!='T')
	i++;
      answer=i;
    }
  }
  else{
    for(i=0;i<size;i++)
      if(!strcmp(m_arr[i].parent,m_arr[branch_index].name)&&
	 !m_arr[i].t_mark){
	while(m_arr[i].type!='T'){
	  i++; 
	}
	answer=i;
      }
  }


  if(answer==-999){
    i=branch_index;
    if(!all_T_counted(branch_index,size)&&
       !domain_T(m_arr[branch_index].name,"basal",size)){
      printf("all_T_counted NOT!!\n");
      exit(0);
    }


    if(all_T_counted(branch_index,size))
      m_arr[branch_index].t_mark=777; 
    if((temp=domain_T(m_arr[branch_index].name,"basal",size))&&
       !m_arr[branch_index].t_mark){
      i=temp;
      while(m_arr[i].type!='T')
	i++;
    }
    else{
      if(!strcmp(m_arr[branch_index].parent,".")&&
	 (m_arr[branch_index-1].type!='B')){
	i--;
	if(m_arr[i].t_mark){
	  while(strcmp(m_arr[i].parent,".")&&(m_arr[i-1].type!='B')){
	    m_arr[i].t_mark=666; 
	    i--;
	  }
	  if(strcmp(m_arr[i].parent,"."))
	    i=find_index(m_arr[i].parent);
	  else
	    i--;
	}
      }
      else{
	if(strcmp(m_arr[branch_index].parent,".")){
	  i=find_index(m_arr[branch_index].parent);
	  while((m_arr[i].type!='B')&&(!strcmp(m_arr[i+1].parent,"."))
		&&strcmp(m_arr[i].parent,"none")){
	    
	    m_arr[i].t_mark=555; 
	    i--;
	  }
	}
	if(m_arr[branch_index-1].type=='B'){
	  i=find_child(m_arr[branch_index-1].name);
	  while(m_arr[i].type!='T')
	    i++;
	}
      }
    }
    answer=i;
  }
  return(answer);
}
   



/************************************************************************

			       calc_T_x

		 Calculates x positions of T points.

************************************************************************/

void calc_T_x(int index,double x_tab, int size)
{
  int flag,i,branch_index;
  double inc;
  
  i=index;

  flag=0;
  if(m_arr[index].type=='T'){
    flag=1;
    calc_T_y(index,size); 
  }


  if((m_arr[index].type!='B')||((m_arr[index].type=='B')&&
     all_T_counted(index,size))){
    if(m_arr[index].type=='T'){ /* used to be != 'B' */
      m_arr[index].x1=x_tab;
      m_arr[index].x2=x_tab;
    }
    if(!m_arr[i].t_mark)
      m_arr[index].t_mark=444;
  }

  while((!strcmp(m_arr[i].parent,".")&&(m_arr[i-1].type!='B'))&&(i>0)){
    i--;
    if(flag){
      m_arr[i].x1=x_tab;
      m_arr[i].x2=x_tab;
    }
    if(!m_arr[i].t_mark)    
      m_arr[i].t_mark=333;
  }


  if(strcmp(m_arr[i].parent,".")&&strcmp(m_arr[i].parent,"none")){
    branch_index=0;
    while(strcmp(m_arr[i].parent,m_arr[branch_index].name)){
      branch_index++;
    }
  }
  if(m_arr[i-1].type=='B')
    branch_index=i-1;

  inc=1.0;
  if(flag)
    x_tab+=inc;

  if(!m_arr[0].t_mark)
    calc_T_x(other_T(branch_index,size),x_tab,size);
}





/************************************************************************

			      calc_horiz

	    Generates horizontal bars seen in dendrogram.

************************************************************************/

int calc_horiz(int size)
{
  int i,j,k,add_size;
  double small_big[2][2];

  add_size=0;
  for(i=0;i<size;i++)
    if(m_arr[i].type=='B'){
      small_big[0][0]=m_arr[i+1].x1;
      small_big[0][1]=m_arr[i+1].y1;
      small_big[1][0]=m_arr[i+1].x1;
      small_big[1][1]=m_arr[i+1].y1;
      for(j=0;j<size;j++)
	if(!strcmp(m_arr[i].name,m_arr[j].parent)){
	  if(m_arr[j].x1<small_big[0][0]){
	    small_big[0][0]=m_arr[j].x1;
	    small_big[0][1]=m_arr[j].y1;  
	  }
	  if(m_arr[j].x1>small_big[1][0]){
	    small_big[1][0]=m_arr[j].x1;
	    small_big[1][1]=m_arr[j].y1;  
	  }
	}
      m_arr[size+add_size].x1=small_big[0][0];
      m_arr[size+add_size].y1=small_big[0][1];
      m_arr[size+add_size].x2=small_big[1][0];
      m_arr[size+add_size].y2=small_big[0][1];	
      m_arr[size+add_size].d=0;
      add_size++;
    }
  return(size+add_size);
}




/************************************************************************

			     convert_to_m

	   Creates m_arr which will contain the dendrogram.

************************************************************************/

void convert_to_m(int T_num, int size)
{
  int i,j,k,count_T;
  double x_inc;

  for(i=0;i<size;i++){
    strcpy(m_arr[i].name,inter_arr[i].name);
    strcpy(m_arr[i].parent,inter_arr[i].parent);
    m_arr[i].type=inter_arr[i].type;
    m_arr[i].morph=inter_arr[i].morph;
    m_arr[i].d=inter_arr[i].d;
  }


  calc_T_x(size-1,1.0,size);
  calc_B_x(size);
}




/************************************************************************

			      write_file

			 Writes output file.

************************************************************************/


void write_file(char *file_name, int size)
{
  FILE *fp;
  int i;

  if((fp=fopen(file_name,"w"))==NULL){
    printf("CANNOT WRITE TO %s\n",file_name);
    exit(0);
  }

  for(i=0;i<size;i++){
    fprintf(fp,"%.2f %e %.2f %e %.2f\n",m_arr[i].x1,m_arr[i].y1,
	    m_arr[i].x2,m_arr[i].y2,m_arr[i].d);
  }

  fclose(fp);
}




