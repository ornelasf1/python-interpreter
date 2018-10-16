%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include"node.h"

extern int yylex();
extern void yyerror(const char *);

%}
%union {
    int num;
	char *w;
}
%token  add subtract multiple divide
%token exit_command newLine  quote  
%token function_defined colon tab 
%token print IF  funcReturn
%nonassoc NO_ELSE
%nonassoc ELSE
%left LT GT EQUAL NOT_EQUAL LTE GTE

%token <w> WORD
%token <w> IDENTIFIER
%token <num> NUMBER
%left comma
%right assign
%left add subtract
%left multiple divide
%left left_b right_b

%type <num> exp exp_list  selection_statement term assignment function line RELATIONAL EQUALITY


%start line


%%



line: assignment newLine				{;}
		| newLine						{;}
		|selection_statement			{;}
		| function						{;}
		| line function					{;}
		| line newLine					{;}
		| exit_command					{return 0;}
		| exit_command newLine			{return 0;}
		| line assignment newLine		{;}
		| line exit_command newLine		{return 0;}
		| print left_b exp right_b newLine	{;}
		| tab funcReturn line			{;}						
		| print left_b  WORD   right_b newLine {;}
		| print left_b  WORD comma exp   right_b newLine  {;}
		| line print left_b exp right_b newLine	{;}
		| line print left_b  WORD   right_b newLine {;}
		| line print left_b  WORD comma exp   right_b newLine {;}

        ;
selection_statement: IF left_b exp right_b line %prec NO_ELSE {;}
  | IF left_b exp right_b line ELSE line						{;}
;



assignment: IDENTIFIER assign exp  {;}
;

exp: term                  		{;}
 		| RELATIONAL     			 {; }
  		| EQUALITY       		 { ; }
		| exp add exp          			 {;}
       	| exp subtract exp     			 {;}
		| exp multiple exp    			 {;}
		| exp divide exp       			 {;}
		| IDENTIFIER left_b right_b            { ; }
		| IDENTIFIER left_b  exp_list right_b  {; }
       	;
RELATIONAL: exp GT exp 	{;}
	| exp LT exp 	{;}
	|  exp GTE exp 	{;}
	| exp LTE exp 	{;}
;
EQUALITY: exp EQUAL exp {;}
	|	exp NOT_EQUAL exp {;}

exp_list: exp			{;}
  | exp comma exp_list { ; }
;


term: NUMBER                {;}
		| IDENTIFIER        {;}
;

function: function_defined IDENTIFIER left_b right_b            { ; }
		| tab line					{;}


%%                     /* C++ code */



Node* CreateNode(NodeType type,int val, Node* left, Node* right)
   {
      Node* node = new Node;
      node->Type = type;
	  node->Value = val;
      node->Left = left;
      node->Right = right;

      return node;
   }

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}


