%{
    #include <ctype.h>
    
    #define NUMBER 100
    #define PLUS 101
    #define MINUS 102
    #define MUL 103
    #define DIV 104
    #define LPAREN 105
    #define RPAREN 106
    #define EOLINE 107
%}

%%

[0-9]+ {
    printf("Got  %s\n", yytext);
    return NUMBER;
}

"+"  { 
    printf("Got sign %s\n", yytext);
    return(PLUS);
}


"-"  { 
    printf("Got sign %s\n", yytext);
    return(MINUS);
}


"*" { 
    printf("Got sign %s\n", yytext);
    return(MUL);
}


"/" { 
    printf("Got sign %s\n", yytext);
    return(DIV);
}


"(" { 
    printf("Got sign %s\n", yytext);
    return(LPAREN);
}


")" { 
    printf("Got sign %s\n", yytext);
    return(RPAREN);
}


"\n" { 
    printf("Got END of line\n", yytext);
    return(EOLINE);
}

%%

int yywrap() {
    return 1;
}

int main() {
    int tok;
    printf("Entered  %s\n", __FUNCTION__);
    //yylex();
    while( (tok = yylex()) != EOLINE )     
        printf("tok = %d\n", tok);
    printf("Exited  %s\n", __FUNCTION__);
    return 0;
}
