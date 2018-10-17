%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include"node.h"

extern int yylex();
extern void yyerror(const char *);




%}
%union {
    int num;
	char *w;
}
%token exit_command newLine  '\"'  
%token function_defined   
%token print IF  funcReturn tab ELSE
%left LT  GT EQUAL NOT_EQUAL LTE GTE

%token <w> WORD
%token <w> IDENTIFIER
%token <num> NUMBER
%left ','
%right '=' ':'
%left '+' '-'
%left '*' '/'
%left left_b right_b

%type <num> exp  selection_statement term assignment function line block printing


%start line


%%



line: assignment newLine				{;}
		| newLine						{;}
		| exp newLine					{;}
		| line exp newLine					{;}
		| selection_statement newLine		{;}
		| line selection_statement newLine		{;}
		| function newLine				{;}
		| line function	newLine				{;}
		| line newLine					{;}
		| exit_command					{return 0;}
		| line assignment newLine		{;}
		| line exit_command newLine		{return 0;}
		| printing newLine					{;}
		| block newLine					{;}
		| line block newLine			{;}

        ;
printing:print left_b exp right_b 	{printf("print left_b exp right_b\n");}					
		| print left_b  WORD   right_b  {printf("print left_b  WORD   right_b \n");}
		| print left_b  WORD ',' exp   right_b   {printf("print left_b  WORD ',' exp   right_b  \n");}
		| line print left_b exp right_b 	{printf(" line print left_b exp right_b\n");}
		| line print left_b  WORD   right_b  {printf("line print left_b  WORD   right_b  \n");}
		| line print left_b  WORD ',' exp   right_b  {printf("line print left_b  WORD ',' exp   right_b \n");}
;
selection_statement: IF left_b exp right_b ':'	{printf("IF left_b exp right_b  \n ");}
		| ELSE ':' 	{printf(" ELSE ':' \n ");}
;

assignment: IDENTIFIER '=' exp  {printf("IDENTIFIER '=' exp \n ");}
;

exp: term                  		{printf("term\n ");}
 		| exp LT exp 	{printf(" exp '>' exp\n");}
		| exp GT exp 	{printf("exp '<' exp \n ");}
		| exp GTE exp 	{printf("exp >= exp \n");}
		| exp LTE exp 	{printf("exp <= exp\n ");}
  		| exp EQUAL exp {printf("exp == exp \n");}
		| exp NOT_EQUAL exp {printf("exp != exp\n ");}
		| exp '+' exp          			 {printf("exp '+' exp \n");}
       	| exp '-' exp     			 {printf("exp '-' exp \n");}
		| exp '*' exp    			 {printf("exp '*' exp \n ");}
		| exp '/' exp       			 {printf(" exp '/' exp \n");}
		| IDENTIFIER left_b right_b            {printf("IDENTIFIER left_b right_b\n ") ; }
;



term: NUMBER                {printf("NUMBER\n ");}
		| IDENTIFIER        {printf(" IDENTIFIER\n");}
;

function: function_defined IDENTIFIER left_b right_b ':'           { printf("function_defined IDENTIFIER\n"); }
;

block:tab exp {printf("tab exp \n");}
	| tab funcReturn exp 			{printf("tab funcReturn exp newLine \n");}	
	| tab printing 				{printf("tab printing newLine \n");}
	| tab assignment 			{printf("tab assignment \n");}
	| block tab exp {printf("tab exp \n");}
	| block tab funcReturn exp 			{printf("tab funcReturn exp newLine \n");}	
	| block tab printing 				{printf("tab printing newLine \n");}
	| block tab assignment 			{printf("tab assignment \n");}
;


%%                     /* C++ code */



// Node* CreateNode(NodeType type,int val, Node* left, Node* right)
//    {
//       Node* node = new Node;
//       node->Type = type;
// 	  node->Value = val;
//       node->Left = left;
//       node->Right = right;

//       return node;
//    }

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}


