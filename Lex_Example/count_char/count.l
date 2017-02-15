%{
    int nChars = 0;
    int nWords = 0;
    int nLines = 0;
%}

%%

[^ \t]  { nWords++; nChars++; }
.       { nChars++; }
\n      { nLines++; nChars++; }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Entered %s\n", __FUNCTION__);
    yylex();
    printf("nChars = %d\tnWords = %d\tnLine = %d\n", nChars, nWords, nLines);
    printf("Exited %s\n", __FUNCTION__);
    return 0;
}
