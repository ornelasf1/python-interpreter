%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string.h>
#include <vector>
#include "mypython.h"


using std::vector;

extern int yylex();
extern void yyerror(const char *);



// #define YYDEBUG 1
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

%type <num> exp statement selection_statement term assignment function line  printing 


%start line


%%



line: tab statement newLine					{;}
		| line tab statement newLine			{;}
		| statement newLine							{;}
		| line statement newLine				{;}
		| newLine								{;}
		| line newLine							{;}
		| exit_command							{return 0;}
		| line exit_command newLine				{return 0;}
		
		
;
statement:assignment 							{;}
	| exp 							{ ; }
	| selection_statement 			{;}
	| function 						{;}
	| printing 						{;}
;
printing:print left_b exp right_b 	{printf("%d\n",$3);}					
		| print left_b  WORD   right_b  {
											std::string str($3);
											str.erase(0, 1);
											str.erase(str.size() - 1);
											printf(str.c_str());
											}
		| print left_b  WORD ',' exp   right_b   {std::string str($3);
											str.erase(0, 1);
											str.erase(str.size() - 1);
											printf(str.c_str());;printf("%d\n",$5);}
;
selection_statement: IF left_b exp right_b ':' exp 	{if($3){printf("its true");}else{printf("its false");}}
		| ELSE ':' 	{printf(" ELSE ':' \n ");}
;

assignment: IDENTIFIER '=' exp  {if(program->variables.size() >= 1){
		for(int i = 0; i < program->variables.size(); i++){
			if($1 == program->variables[i].getIdentifier()){
				program->variables[i].setIntValue($3);
				break;
			}else if($1 != program->variables[i].getIdentifier() && i == program->variables.size() - 1){
				Variable* var = new Variable($1, $3, "INT");
				program->variables.push_back(*var);
			}
		}
	}else{
		Variable* var = new Variable($1, $3, "INT");
		program->variables.push_back(*var);
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
       	| exp '-' exp     			 {$$=$1-$3;}
		| exp '*' exp    			 {$$=$1*$3;}
		| exp '/' exp       			 {$$=$1/$3;}
		| IDENTIFIER left_b right_b            { 
			for(int i = 0; i < program->functions.size(); i++){
				if((strcmp($1, program->functions[i].identifier.c_str())) == 0){
					$$ = program->functions[i].returnValue;
				}else{
					$$ = -1;
				}
    		}
			;}
;



term: NUMBER                {$$=$1;}
		| IDENTIFIER        {std::string str($1);
			Variable* value = program->getVariable(str);
			if(value)
				$$ = value->getIntValue();
			else
				yyerror("unknown variable");
		}
;

function: function_defined IDENTIFIER left_b right_b ':'           { 
	Function* func = new Function($2, 0, program->variables);
	program->functions.push_back(*func);
	}
		| funcReturn exp					{
			program->functions.front().returnValue = $2;
			}
;

%%                     /* C++ code */


	
		

	 
void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}


