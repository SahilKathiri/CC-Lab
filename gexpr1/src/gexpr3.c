#include "gComp.h"

main(int argc, char *argv[] )
{
	char exprStr[100];
	token_t tok;
	int ans, quit = 0;


	initSymbolTable();
	do {
		if ( isatty(fileno(stdin))) printf("?? ");
		getToken(&tok);
		if (tok.tType == EOF) break;
		if (tok.tType != EOLN) parseStatment(&tok);
	} while(1);
}

int parseStatment(token_t *tok)
{
	switch (tok->tType ) {
		case ID : parseAssignment(tok);  break;
		//case IF :
		//case WHILE:
		
		default : print_error ("Unknown token\n");
	}
}


int parseAssignment(token_t *tok)
{	
	char id[MAX_ID_LEN];
	int ans;	
	

	strcpy(id, tok->tVal.tStr);
	DPRINTF ("%s: Got Id = %s\n", __FUNCTION__, id);
	getToken(tok);
	if ( tok->tType == EQUALS) {
		DPRINTF ("%s: Got EQUALS\n", __FUNCTION__ );
		getToken(tok);
		parseExpr(tok, &ans);
		insertSymbolTable(id, ans);	
		printf("\tmovl\t%s, %s\n", "%eax", id);
	} else {
		int status = searchSymbolTable(id,&ans);
		printf("%s = %d\n", id, ans);
	}
	if (tok->tType != SEMICOLON ) {
		print_error( "SEMICOLON expected\n");
	}
	getToken(tok);
}


int parseExpr(token_t *tok, int *ans)
{
	parsePlusMinus(tok, ans);
	return OK;
}


int parsePlusMinus(token_t *tok, int *ans)
{
	int ans1, ans2;
	int operator;

	DPRINTF ("%s: BEGIN\n", __FUNCTION__);
	parseMulDiv(tok, &ans1);
	DPRINTF ("%s: ans1 = %d\n", __FUNCTION__, ans1);
	while ( ((operator=tok->tType) == PLUS) || (operator == MINUS) ) {
		DPRINTF ("%s: op = %d\n", __FUNCTION__, operator);
		printf("\tpushl\t%s\n", "%eax");	
		getToken(tok);
		parseMulDiv(tok, &ans2);	
		printf("\tpopl\t%s\n", "%ebx");
		DPRINTF ("%s: ans1 = %d\n", __FUNCTION__, ans2);
		if (operator == PLUS ) {
			ans1 += ans2;
			printf("\taddl\t%s, %s\n", "%ebx", "%eax");
		} else {
			ans1 -= ans2;
			printf("\tsubl\t%s, %s\n", "%ebx", "%eax");
		}
	}
	*ans = ans1;
	DPRINTF ("%s: END\n", __FUNCTION__);
}


int parseMulDiv(token_t *tok, int *ans)
{
	int ans1, ans2;
	int operator;

	DPRINTF ("  %s: BEGIN\n", __FUNCTION__);
	parseFactor(tok, &ans1);
	DPRINTF ("  %s: ans1 = %d\n", __FUNCTION__, ans1);
	while ( ((operator=tok->tType) == MUL) || (operator == DIV) ) {
		DPRINTF ("  %s: op = %d\n", __FUNCTION__, operator);
		getToken(tok);
		printf("\tpushl\t%s\n", "%eax");	
		parseFactor(tok, &ans2);
		printf("\tpopl\t%s\n", "%ebx");
		DPRINTF ("  %s: ans2 = %d\n", __FUNCTION__, ans2);
		if (operator == MUL ) {
			ans1 *= ans2;
			printf("\timul\t%s, %s\n", "%ebx", "%eax");
		} else {
			ans1 /= ans2;
			printf("\tidiv	TODO\n");
		}
	}
	*ans = ans1;
	DPRINTF ("  %s: END\n", __FUNCTION__);
}

int parseFactor(token_t *tok, int *ans)
{
	DPRINTF ("    %s: BEGIN\n", __FUNCTION__);
	switch (tok->tType) {
		case NUMBER : 
			*ans = tok->tVal.tInt;
			printf ("\tmovl\t$%d, %s\n",tok->tVal.tInt, "%eax");
			DPRINTF ("    %s: ans = %d\n", __FUNCTION__, *ans);
			DPRINTF ("    %s: END\n", __FUNCTION__);
			getToken(tok);
			return OK;
			break;
		case ID : 
			searchSymbolTable(tok->tVal.tStr,ans);
			printf ("\tmovl\t%s, %s\n",tok->tVal.tStr, "%eax");
			DPRINTF ("    %s: ans = %d\n", __FUNCTION__, *ans);
			DPRINTF ("    %s: END\n", __FUNCTION__);
			getToken(tok);
			return OK;
			break;
		case LRB :
			getToken(tok);
			parseExpr(tok, ans);
			DPRINTF ("    %s: ans = %d\n", __FUNCTION__, *ans);
			DPRINTF ("    %s: END\n", __FUNCTION__);
			if ( tok->tType != RRB) {
				print_error("RRB expected\n");
			}
			getToken(tok);
			return OK;
			break;
		default:
			print_error( " NUMBER or ( expected\n");
			DPRINTF ("    %s: END\n", __FUNCTION__);
			return NOK;
	} 
	DPRINTF ("    %s: END\n", __FUNCTION__);
}


