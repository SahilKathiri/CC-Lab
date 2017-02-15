%%
tom { printf("jerry"); }
"jerry" printf("tom");

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Entered %s\n", __FUNCTION__);
    yylex();
    printf("Exited %s\n", __FUNCTION__);
    return 0;
}
