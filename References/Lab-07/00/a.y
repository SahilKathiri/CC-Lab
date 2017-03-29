%{
#include <stdio.h>
#include <ctype.h>
%}

%token PLUS MUL DIGIT LRP RRP EOLN

/*
  E -> E + T | T
  T -> T * F | F
  F -> digit | ( E )
*/


%%

lines	: lines expr EOLN  { printf ("Expr is valid\n");}
	| lines EOLN  { printf ("Expr is valid\n");}
	|
	;

expr	: expr PLUS term
	| term
	;

term	: term MUL fact
	| fact
	;

fact 	: DIGIT
	| LRP expr RRP
	;

%%
int yylex()
{
  int c = getchar();
  switch (c) {
    case '+' : return PLUS;
    case '*' : return MUL;
    case '(' : return LRP;
    case ')' : return RRP;
    case '\n': return EOLN;
    default: if ( isdigit(c) ) {
		return DIGIT;
	     }
  }
}

void yyerror(char *msg)
{
  printf("error in input %s\n", msg);
  exit(1);
}

int main()
{
  yyparse();
}
