%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YY_DECL int yylex()
#include "calc.tab.h"

%}

%%

[0-9]+                 {yylval.num = atoi(yytext); return NUMBER;}
"print"				   {return print;}
"exit"				   {return exit_command;}
"def"                   {return function_defined;}
"if"                    {return IF;}
"else"                  { return ELSE;}
"return"                {return funcReturn;}
"<"                     {return LT; }
"<="                    {  return LTE; }
">"                     {  return GT; }
">="                    {  return GTE ; }
"=="                    { return EQUAL; }
"!="                    {  return NOT_EQUAL; }
"\s\s\s\s"                   {return tab; }
":"                     {return ':';}
"+"                     {return '+';}
"-"                     {return '-';}
"*"                     {return '*';}
"/"                     {return '/' ;}
"="                     {return '=' ;}
"\""                    {return '\"' ;}
"("                     {return left_b;}
")"                     {return right_b ;}
","                     {return ',';}
[a-zA-Z0-9_-]+   {yylval.w = strdup(yytext); return IDENTIFIER;}
\"([^\\\"]|\\.)*\"      {yylval.w = strdup(yytext); return WORD;}
[#]([^\\\"]|\\.)*\n             ;
"\n"                    {return newLine;}
[ ]                 ;
.                   ;
%%
