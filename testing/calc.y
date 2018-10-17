%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include "mypython.h"

using std::vector;

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

%type <num> exp  selection_statement term assignment function line  printing 


%start line


%%



line:tab newLine                   {printf(" tabsss\n");}
		| tab exp newLine {printf("tab exp \n");}
		| tab funcReturn exp newLine			{printf("tab funcReturn exp newLine \n");}	
		| tab printing newLine			{printf("tab printing newLine \n");}
		| tab assignment newLine			{printf("tab assignment \n");}
		| tab selection_statement newLine			{printf("tab selection_statement \n");}
		| line tab newLine                   {printf(" tabsss\n");}
		| line tab exp newLine {printf("tab exp \n");}
		| line tab funcReturn exp newLine			{printf("tab funcReturn exp newLine \n");}	
		| line tab printing newLine			{printf("tab printing newLine \n");}
		| line tab assignment newLine			{printf("tab assignment \n");}
		| line tab selection_statement newLine			{printf("tab selection_statement \n");}
		| assignment newLine				{;}
		| newLine						{;}
		| exp newLine					{ printf("%d\n",$1); }
		| line exp newLine					{$$;}
		| selection_statement newLine		{;}
		| line selection_statement newLine		{;}
		| function newLine				{;}
		| line function	newLine				{;}
		| line newLine					{;}
		| exit_command					{return 0;}
		| line assignment newLine		{;}
		| line exit_command newLine		{return 0;}
		| printing newLine					{;}
		
;

printing:print left_b exp right_b 	{printf("%d\n",$3);}					
		| print left_b  WORD   right_b  {printf($3);}
		| print left_b  WORD ',' exp   right_b   {printf($3);printf("%d\n",$5);}
		| line print left_b exp right_b 	{printf("%d\n",$4);}
		| line print left_b  WORD   right_b  {printf($4);}
		| line print left_b  WORD ',' exp   right_b  {printf($4);printf("%d\n",$6);}
;
selection_statement: IF left_b exp right_b ':'	{if($3){printf("this works");}}
		| ELSE ':' 	{printf(" ELSE ':' \n ");}
;

assignment: IDENTIFIER '=' exp  {if(variables.size() >= 1){
		for(int i = 0; i < variables.size(); i++){
			if($1 == variables[i].getIdentifier()){
				variables[i].setIntValue($3);
				break;
			}else if($1 != variables[i].getIdentifier() && i == variables.size() - 1){
				Variable* var = new Variable($1, $3, "INT");
				variables.push_back(*var);
			}
		}
	}else{
		Variable* var = new Variable($1, $3, "INT");
		variables.push_back(*var);
	}}
;

exp: term                  		{$$=$1;}
 		| exp LT exp 		{if($1<$3){$$=true;}else{$$=false;}}
		| exp GT exp 		{if($1>$3){$$=true;}else{$$=false;}}
		| exp GTE exp 		{if($1>=$3){$$=true;}else{$$=false;}}
		| exp LTE exp 		{if($1<=$3){$$=true;}else{$$=false;}}
  		| exp EQUAL exp 	{if($1==$3){$$=true;}else{$$=false;}}
		| exp NOT_EQUAL exp {if($1!=$3){$$=true;}else{$$=false;}}
		| exp '+' exp          			 {$$=$1+$3;}
       	| exp '-' exp     			 {$$=$1+$3;}
		| exp '*' exp    			 {$$=$1+$3;}
		| exp '/' exp       			 {$$=$1+$3;}
		| IDENTIFIER left_b right_b            {printf("IDENTIFIER ()\n ") ; }
;



term: NUMBER                {$$=$1;}
		| IDENTIFIER        {std::string str($1);
			Variable* value = getVariable(str);
			if(value)
				$$ = value->getIntValue();
			else
				yyerror("unknown variable");
		}
;

function: function_defined IDENTIFIER left_b right_b ':'           { printf("function_defined IDENTIFIER\n"); }
;

%%                     /* C++ code */


	
		

	 
void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}


