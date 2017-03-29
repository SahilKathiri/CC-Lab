%{
#include <stdio.h>
#define MAX_LEN  10
%}

%token	NUMBER

%%


fact	: NUMBER   { printf ("Got a number\n"); }
		;


%%

int main()
{
	yyparse();
	return 0;
}

int yylex()
{
	int c = getchar(), i;
	char numStr[MAX_LEN];

    i = 0;
	if ( isdigit(c)) {
		while (isdigit(c)) {
          numStr[i++] = c;
          c = getchar();
		}
		return NUMBER;
	}
}


void yyerror(char *msg)
{
	printf("ERROR %s\n", msg);
}