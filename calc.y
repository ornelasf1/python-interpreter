%{

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <vector>
#include "mypython.h"

using std::vector;

extern int yylex();
extern int yyparse();


extern FILE* yyin;
// int symbols[52];

// int symbolVal(char symbol);
// void updateSymbolVal(char symbol, int val);

//#define YYDEBUG 1

void yyerror(const char *s);

%}

%union {
	int num;
	float fval;
	char *w;
}      
	    /* Yacc definitions */
%token print add subtract multiple divide
%token exit_command newLine assign quote left_b right_b comma
%token function_defined colon tab

%left add subtract
%left multiple divide
%token <w> WORD
%token <num> NUMBER
%token<fval> floats
%token <w> identifier
%type <num> line exp term 
%type <w> assignment

%start line


%%

/* descriptions of expected inputs     corresponding actions (in C) */

line: assignment newLine				{;}
		| newLine						{;}
		| line newLine						{;}
		| exit_command					{return 0;}
		| exit_command newLine			{return 0;}
		| print left_b exp right_b newLine				{printf("%d\n", $3);}
		| line assignment newLine		{;}

		| line print left_b exp right_b newLine		{printf("%d\n", $4);}
		| line exit_command newLine		{return 0;}
		| print left_b  WORD   right_b newLine      {printf("%s\n",$3);}
		| print left_b  WORD comma exp   right_b newLine      {printf("%s%d\n",$3,$5);}
		| line print left_b  WORD   right_b newLine      {printf("%s\n",$4);}
		| line print left_b  WORD comma exp   right_b newLine      {printf("%s%d\n",$4,$6);}
		| line function_defined identifier left_b right_b colon newLine	{printf("function found\n");}
        ;

assignment: identifier assign exp  {
	if(variables.size() >= 1){
		for(int i = 0; i < variables.size(); i++){
			printf("%s and %s\n", $1, variables[i].getIdentifier().c_str());
			if($1 == variables[i].getIdentifier()){
				printf("%s set\n", $1);
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
	}
}
;

exp: term                  		{$$ = $1;}
		| exp add exp          {$$ = $1 + $3;}
       	| exp subtract exp     {$$ = $1 - $3;}
		| exp multiple exp    	{$$ = $1 * $3;}
		| exp divide exp       {$$ = $1 / $3;}
       	;

term: NUMBER                {$$ = $1;}
		| identifier        {
			std::string str($1);
			Variable* value = getVariable(str);
			if(value)
				$$ = value->getIntValue();
			else
				yyerror("unknown variable");
		}
        ;

%%                     /* C++ code */

// int computeSymbolIndex(char token)
// {
// 	int idx = -1;
// 	if(islower(token)) {
// 		idx = token - 'a' + 26;
// 	} else if(isupper(token)) {
// 		idx = token - 'A';
// 	}
// 	return idx;
// } 

// /* returns the value of a given symbol */
// int symbolVal(char symbol)
// {
// 	int bucket = computeSymbolIndex(symbol);
// 	return symbols[bucket];
// }

// /* updates the value of a given symbol */
// void updateSymbolVal(char symbol, int val)
// {
// 	int bucket = computeSymbolIndex(symbol);
// 	symbols[bucket] = val;
// }


// int main() {
// 	yyin = stdin;

// 	do {
// 		yyparse();
// 	} while(!feof(yyin));

// 	return 0;
// }




void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	// exit(1);
}