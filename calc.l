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

[0-9]+                 {yylval.num = atoi(yytext); return NUMBER;}
[0-9]+\.[0-9]+         {yylval.fval = atof(yytext); return floats;}
"print"				   {return print;}
"exit"				   {return exit_command;}
"def"                   {return function_defined;}
"   "                   {return tab;}
":"                     {return colon;}
"+"                     {return add;}
"-"                     {return subtract;}
"*"                     {return multiple;}
"/"                     {return divide;}
"="                     {return assign;}
"\""                    {return quote;}
"("                     {return left_b;}
")"                     {return right_b;}
","                     {return comma;}
[a-zA-Z0-9_-]+			{yylval.w = strdup(yytext); return identifier;}
\"([^\\\"]|\\.)*\"     {yylval.w = strdup(yytext); return WORD;}
"\n"                    {return newLine;}
[ ]                     ;
.                       ;

%%


int yywarp (void) {return 1;}