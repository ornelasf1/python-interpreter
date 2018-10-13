%option noyywrap

%{

#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"

%}

%%

[ \t]	       ;// ignore all whitespace
[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+		{yylval.ival = atoi(yytext); return T_INT;}

\n		{return T_NEWLINE;}

"="     {return T_ASSIGN;}
"+"		{return T_PLUS;}
"-"		{return T_MINUS;}
"*"		{return T_MULTIPLY;}
"/"		{return T_DIVIDE;}
"("		{return T_LEFT;}
")"		{return T_RIGHT;}
"(    )+"   {return T_TAB;}
"exit"  {return T_QUIT;}
"print" {return T_PRINT;}
"\""    {return T_QUOTE;}
"#"     {return T_COMMENT;}

[a-zA-Z0-9]+    {yylval.string = strdup( yytext ); return T_STRING;}

%%
