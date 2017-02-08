#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>

#define MAX_TOK_LEN 10
#define MAX_ID_LEN 10
#define NOK 	-1
#define OK 	0
#define NUMBER	1
#define ID	2
#define PLUS	3
#define MINUS	4
#define MUL	5
#define DIV	6
#define LRB	7
#define RRB	8
#define EQUALS	9
#define SEMICOLON 10
#define EOLN	11
#define EXP	12

//#define DEBUG

#ifdef DEBUG
#define DPRINTF printf
#else 
#define DPRINTF  
#endif

typedef struct token {
	int tType;
	char *curPtr;
	char *unGetPtr;
	union {
		int tInt;
		char tStr[MAX_ID_LEN];
		
	} tVal;
} token_t;

int getToken(token_t *tok);
void unGetToken(token_t *tok);
void initToken(char *exprStr, token_t *tok);
void print_error(char *msg);

