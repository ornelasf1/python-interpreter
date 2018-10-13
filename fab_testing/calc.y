%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string.h>
#include <vector>
#include "mypython.h"

using std::vector;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

//#define YYDEBUG 1

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
	char *string;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<string> T_STRING
%token T_ASSIGN
%token T_PLUS T_MINUS T_QUIT T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT T_PRINT T_COLON
%token T_TAB T_QUOTE T_COMMENT
%token T_NEWLINE   
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expression
%type<fval> mixed_expression
%type<ival> assignment

%start lines

%%

lines:
	   | lines line
;

line: T_NEWLINE { printf("new line\n"); }
    | mixed_expression T_NEWLINE { printf("Result: %f\n", $1);}
    | expression T_NEWLINE { printf("found expresstion: %i\n", $1); }
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
	| statement
	| assignment { printf("assignment: %d\n", $1); }
;

assignment: T_STRING T_ASSIGN T_INT {  
	$$ = $3;
	Variable* var = new Variable($1, $3, "INT");
	variables.push_back(*var);
	}
	| T_STRING T_ASSIGN T_QUOTE T_STRING T_QUOTE {  
		/*$$ = $4;*/
		Variable* var = new Variable($1, $4, "STRING");
		variables.push_back(*var);
	}
    | T_STRING T_ASSIGN T_FLOAT {  
		$$ = $3;
		Variable* var = new Variable($1, $3, "FLOAT");
		variables.push_back(*var);
	}
;

statement: T_PRINT T_LEFT T_QUOTE T_STRING T_QUOTE T_RIGHT T_NEWLINE { printf("%s\n", $4);}
	| T_PRINT T_LEFT T_INT T_RIGHT T_NEWLINE { printf("%d\n", $3);}
	| T_PRINT T_LEFT T_STRING T_RIGHT T_NEWLINE { 
		std::string str($3);
		Variable* value = getVariable(str);
		if(value)
			Variable::printVariableValue(value);
		else
			yyerror("unknown variable");
	}
;

mixed_expression: T_FLOAT                 		 { $$ = $1; }
	  | mixed_expression T_PLUS mixed_expression	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS mixed_expression	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY mixed_expression { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | T_LEFT mixed_expression T_RIGHT		 { $$ = $2; }
	  | expression T_PLUS mixed_expression	 	 { $$ = $1 + $3; }
	  | expression T_MINUS mixed_expression	 	 { $$ = $1 - $3; }
	  | expression T_MULTIPLY mixed_expression 	 { $$ = $1 * $3; }
	  | expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | mixed_expression T_PLUS expression	 	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS expression	 	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY expression 	 { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE expression	 { $$ = $1 / $3; }
	  | expression T_DIVIDE expression		 { $$ = $1 / (float)$3; }
;

expression: T_INT				{ $$ = $1; }
	  | expression T_PLUS expression	{ $$ = $1 + $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
;

%%

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
}
