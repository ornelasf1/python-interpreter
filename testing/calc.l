%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YY_DECL int yylex()
#include "calc.tab.h"
%}

string_const (\"(\\.|[^"])*\")
%%

[0-9]+                 {yylval.num = atoi(yytext); return number;}
[0-9]+\.[0-9]+         {yylval.fval = atof(yytext); return floats;}
"print"				   {return print;}
"exit"				   {return exit_command;}
"+"                     {return add;}
"-"                     {return subtract;}
"*"                     {return multiple;}
"/"                     {return divide;}
"="                     {return assign;}
"\""                    {return quote;}
"("                     {return left_b;}
")"                     {return right_b;}
","                     {return comma;}
[a-zA-Z]			   {yylval.id = yytext[0]; return identifier;}
\"([^\\\"]|\\.)*\"     {yylval.w = strdup(yytext);return word;}
"\n"                    {return newLine;}
[ ]                     ;

%%


int yywarp (void) {return 1;}