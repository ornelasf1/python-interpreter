%{

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
extern int yylex();
extern int yyparse();

extern FILE* yyin;
int symbols[52];

int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
void yyerror(const char *s);

%}

%union {
	int num;
	 char id;
	 float fval;
	 char *w;
	 }      
	    /* Yacc definitions */
%token print add subtract multiple divide
%token exit_command newLine assign quote left_b right_b comma

%left add subtract
%left multiple divide
%token <w> word
%token <num> number
%token<fval> floats
%token <id> identifier
%type <num> line exp term 
%type <id> assignment

%start line


%%

/* descriptions of expected inputs     corresponding actions (in C) */

line: assignment newLine				{;}
		| exit_command newLine			{exit(EXIT_SUCCESS);}
		| print left_b exp right_b newLine				{printf("%d\n", $3);}
		| line assignment newLine		{;}
		
		| line print left_b exp right_b newLine		{printf("%d\n", $4);}
		| line exit_command newLine		{exit(EXIT_SUCCESS);}
		| print left_b  word   right_b newLine      {printf("%s\n",$3)}
		| print left_b  word comma exp   right_b newLine      {printf("%s%d\n",$3,$5)}
		| line print left_b  word   right_b newLine      {printf("%s\n",$4)}
		| line print left_b  word comma exp   right_b newLine      {printf("%s%d\n",$4,$6)}

        ;

assignment: identifier assign exp  { updateSymbolVal($1,$3); }
			;

exp: term                  		{$$ = $1;}
		| exp add exp          {$$ = $1 + $3;}
       	| exp subtract exp     {$$ = $1 - $3;}
		| exp multiple exp    	{$$ = $1 * $3;}
		| exp divide exp       {$$ = $1 / $3;}
		| exp add add          {$$ = $1+1;}
		| exp subtract subtract          {$$ = $1-1;}
       	;
term: number                {$$ = $1;}
		| identifier        {$$ = symbolVal($1);}
        ;

%%                     /* C++ code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}


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