%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_LEN  10
%}

%token PLUS MUL DIGIT NUMBER LRP RRP EOLN

/*
  E -> E + T | T
  T -> T * F | F
  F -> digit | ( E )
*/


%%

lines	: lines expr EOLN   { printf( "Result = %d\n", $2);}
	| lines EOLN  
	|       
	;

expr	: expr PLUS term   { $$ = $1 + $3; }
	| term                 { $$ = $1;}
	;

term	: term MUL fact    
        {  /*printf ("T1:got %d * %d\n", $1, $3); */
          $$ = $1 * $3; 
        }
	     | fact                 
         { 
           /*printf ("T2:got %d\n", $1); */
            $$ = $1;
          }
	     ;

fact 	: NUMBER           { /*printf ("F1:got %d\n", $1); */ $$ = $1;} 
	| LRP expr RRP    
	;

%%
int yylex()
{
  char str[MAX_LEN];
  int c = getchar();
  int i = 0;
  while (c != '\n' && isspace(c)) c=getchar();
  //printf ("%s:c=%d(%c)\n", __FUNCTION__, c, c);
  switch (c) {
    case '+' : return PLUS;
    case '*' : return MUL;
    case '(' : return LRP;
    case ')' : return RRP;
    case '\n': return EOLN;
    default: if ( isdigit(c) ) {
		while (isdigit(c)) {
      str[i++] = c;
      c = getchar();
		}
    ungetc(c, stdin);
    str[i] = '\0';
    yylval = strtol(str, NULL, 10);
		return NUMBER;
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
