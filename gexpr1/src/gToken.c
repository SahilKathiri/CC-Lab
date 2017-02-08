#include "gComp.h"

token_t curToken;
token_t prevToken;

int getToken(token_t *t) {
	char tStr[MAX_TOK_LEN];
	char *s = t->curPtr;
	char *tStrPtr = tStr;
	int c;
	
	while (1) {
		while ((c=getchar()) != EOF && (c!='\n') && isspace(c));
		switch (c) {
			case '+' : t->tType=PLUS; t->curPtr = 0; return OK;
			case '-' : t->tType=MINUS; t->curPtr = 0; return OK;
			case '^' : t->tType=EXP; t->curPtr = 0; return OK;
			case '*' : t->tType=MUL;t->curPtr = 0;  return OK;
			case '/' : t->tType=DIV;t->curPtr = 0;  return OK;
			case '(' : t->tType=LRB;t->curPtr = 0;  return OK;
			case ')' : t->tType=RRB;t->curPtr = 0;  return OK;
			case '=' : t->tType=EQUALS;t->curPtr = 0;  return OK;
			case ';' : t->tType=SEMICOLON;t->curPtr = 0;  return OK;
			case '\n': t->tType=EOLN;t->curPtr = 0;  return OK;
			case EOF : t->tType=EOF;t->curPtr = 0;  return OK;
			default	 : 
				if (isdigit(c)) {
					do {
						*tStrPtr++ = c;
					}while ( (c=getchar()) !=EOF && isdigit(c) ) ;
					//DPRINTF ("%s: *s= %c\n", __FUNCTION__, *s);
				ungetc(c, stdin);
				*tStrPtr='\0';
				t->tType = NUMBER;
				t->tVal.tInt = strtol(tStr,NULL, 10);
				DPRINTF ("      %s: ans = %d\n", __FUNCTION__, t->tVal.tInt);
				t->curPtr = 0; 
				return OK;
				}
			   	if (isalpha(c)) {
					do {
						*tStrPtr++ = c;
					}while ( (c=getchar()) !=EOF && isalnum(c) ) ; 
					//DPRINTF ("%s: *s= %c\n", __FUNCTION__, *s);
				ungetc(c, stdin);
				*tStrPtr++ = '\0';
				t->tType = ID;
				strcpy(t->tVal.tStr, tStr);
				DPRINTF ("      %s: id = %s\n", __FUNCTION__, t->tVal.tStr);
				t->curPtr = 0; 
				return OK;
			  	}
				printf ("ID/Num expected\n");
				return NOK;
		} // of switch()
		DPRINTF ("      %s: *s= %c\n", __FUNCTION__, *s);
	} // of while()
} // of getToken()

void unGetToken(token_t *tok) {
	tok->curPtr = tok->unGetPtr;
}

void initToken(char *str, token_t *tok) {
 	tok->curPtr = str;
}
