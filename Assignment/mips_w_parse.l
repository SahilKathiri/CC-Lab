%{
	#include <stdio.h>

	#define T_DATA_DIRECTIVE 	100
	#define T_BYTE_DIRECTIVE 	101
	#define T_HALF_DIRECTIVE 	102
	#define T_WORD_DIRECTIVE 	103
	#define T_TEXT_DIRECTIVE 	104
	#define T_GLOBL_DIRECTIVE 	105
	#define T_END_DIRECTIVE 	106

	#define T_REG 				107
	#define T_ADD 				108
	#define T_SUB 				109
	#define T_LOAD_WORD 		110
	#define T_LOAD_IMMEDIATE 	111
	#define T_STORE_WORD 		112
	#define T_ID 				113
	#define T_INT_NUM 			114

	#define T_COLON 			115
	#define T_COMMA 			116
	#define T_WS 				117

	int symtab[26];
	int mem_no;

	int regtab[32];
	int reg_no;

	int yylval;
	int int_number;
%}

id 			[a-zA-Z][a-zA-Z0-9]*
number		[0-9]+
ws			[ \t\n]+

%%

".data"		{ return T_DATA_DIRECTIVE; }
".byte"		{ return T_BYTE_DIRECTIVE; }
".half"		{ return T_HALF_DIRECTIVE; }
".word"		{ return T_WORD_DIRECTIVE; }
".text"		{ return T_TEXT_DIRECTIVE; }
".globl"	{ return T_GLOBL_DIRECTIVE; }
".end"		{ return T_END_DIRECTIVE; }

"$zero"		{ reg_no = 0; return T_REG; }
"$at"		{ reg_no = 1; return T_REG; }
"$v0"		{ reg_no = 2; return T_REG; }
"$v1"		{ reg_no = 3; return T_REG; }

"$a0"		{ reg_no = 4; return T_REG; }
"$a1"		{ reg_no = 5; return T_REG; }
"$a2"		{ reg_no = 6; return T_REG; }
"$a3"		{ reg_no = 7; return T_REG; }

"$t0"		{ reg_no = 8; return T_REG; }
"$t1"		{ reg_no = 9; return T_REG; }
"$t2"		{ reg_no = 10; return T_REG; }
"$t3"		{ reg_no = 11; return T_REG; }
"$t4"		{ reg_no = 12; return T_REG; }
"$t5"		{ reg_no = 13; return T_REG; }
"$t6"		{ reg_no = 14; return T_REG; }
"$t7"		{ reg_no = 15; return T_REG; }

"$s0"		{ reg_no = 16; return T_REG; }
"$s1"		{ reg_no = 17; return T_REG; }
"$s2"		{ reg_no = 18; return T_REG; }
"$s3"		{ reg_no = 19; return T_REG; }
"$s4"		{ reg_no = 20; return T_REG; }
"$s5"		{ reg_no = 21; return T_REG; }
"$s6"		{ reg_no = 22; return T_REG; }
"$s7"		{ reg_no = 23; return T_REG; }

"$t8"		{ reg_no = 24; return T_REG; }
"$t9"		{ reg_no = 25; return T_REG; }

"$k0"		{ reg_no = 26; return T_REG; }
"$k1"		{ reg_no = 27; return T_REG; }

"$gp"		{ reg_no = 28; return T_REG; }
"$sp"		{ reg_no = 29; return T_REG; }
"$fp"		{ reg_no = 30; return T_REG; }
"$ra"		{ reg_no = 31; return T_REG; }

"add"		{ return T_ADD; }
"sub"		{ return T_SUB; }

"li"		{ return T_LOAD_IMMEDIATE; }
"lw"		{ return T_LOAD_WORD; }
"sw"		{ return T_STORE_WORD; }

{id} 		{ 
	// printf("T_ID : %s \n", yytext); 
	yylval = yytext[0] - 'a';
	mem_no = yylval;
	return T_ID;
}

{number}	{ 
	// printf("T_INT_NUM : %s \n", yytext); 
	int_number = strtol(yytext, NULL, 10);
	return T_INT_NUM;
}

{ws}		{}

":"		{ return T_COLON; }
","		{ return T_COMMA; }


%%

void _process_load_word(int tok) {
	if((tok = yylex()) == T_REG) {
		int dest_i = reg_no;
		if((tok = yylex()) == T_COMMA && (tok = yylex()) == T_ID) {
			regtab[dest_i] = symtab[mem_no];
			printf("Load %d <- %d\n", dest_i, mem_no);
		}
	}
}

void _process_load_immediate(int tok) {
	if((tok = yylex()) == T_REG) {
		int dest_i = reg_no;
		if((tok = yylex()) == T_COMMA && (tok = yylex()) == T_INT_NUM) {
			regtab[dest_i] = int_number;
			printf("Load %d <- %d\n", dest_i, int_number);
		}
	}
}

void _process_store_word(int tok) {
	if((tok = yylex()) == T_REG) {
		int dest_i = reg_no;
		if((tok = yylex()) == T_COMMA && (tok = yylex()) == T_ID) {
			symtab[mem_no] = regtab[dest_i];
			printf("Store %d -> %d\n", dest_i, mem_no);
		}
	}
}

void _process_add(int tok) {
	if((tok = yylex()) == T_REG) {
		int res_reg = reg_no;
		if((tok = yylex()) == T_COMMA && (tok = yylex()) == T_REG) {
			int src_reg = reg_no;
			if((tok = yylex()) == T_COMMA && (tok = yylex()) == T_REG) {
				int dest_reg = reg_no;
				regtab[res_reg] = regtab[src_reg] + regtab[dest_reg];
				printf("Add %d <- %d + %d\n", res_reg, src_reg, dest_reg);
			}
		}
	}
}

void _process_sub(int tok) {
	if((tok = yylex()) == T_REG) {
		int res_reg = reg_no;
		if((tok = yylex()) == T_COMMA && (tok = yylex()) == T_REG) {
			int src_reg = reg_no;
			if((tok = yylex()) == T_COMMA && (tok = yylex()) == T_REG) {
				int dest_reg = reg_no;
				regtab[res_reg] = regtab[src_reg] - regtab[dest_reg];
				printf("Sub %d <- %d + %d\n", res_reg, src_reg, dest_reg);
			}
		}
	}
}

void _process_text_directive(int tok) {
	// printf("NOW I AM IN .TEXT\n");
	tok = yylex();
	if(tok == T_GLOBL_DIRECTIVE && (tok = yylex()) == T_ID) {
		if((tok = yylex()) == T_ID && (tok = yylex()) == T_COLON) {
			tok = yylex();
			
			// printf("%d\n", tok);
			while(tok != T_END_DIRECTIVE) {
				switch(tok) {
					case T_LOAD_WORD:
						_process_load_word(tok);
						tok = yylex();
						break;
					case T_LOAD_IMMEDIATE:
						_process_load_immediate(tok);
						tok = yylex();
						break;
					case T_STORE_WORD:
						_process_store_word(tok);
						tok = yylex();
						break;
					case T_ADD:
						_process_add(tok);
						tok = yylex();
						break;
					case T_SUB:
						_process_sub(tok);
						tok = yylex();
						break;
				}
			}
		}
	}

	printf("Symbol Table:\n");
	for (int i = 0; i < 26; ++i) {
		printf("%d  ", symtab[i]);
	}

	printf("\nRegister Table:\n");
	for (int i = 0; i < 32; ++i) {
		printf("%d  ", regtab[i]);
	}

	printf("\nDONE WITH FILE INPUT\n");


}

void _process_data_directive(int tok) {
	tok = yylex();
	while(tok == T_ID) {
		tok = yylex();
		int id = mem_no;
		if(tok == T_COLON) {
			tok = yylex();
			if(tok == T_WORD_DIRECTIVE) {
				tok = yylex();
				if(tok == T_INT_NUM) {
					tok = yylex();
					int num = int_number;
					symtab[id] = num;
					printf("Load Data %d <- %d\n", id, num);
				}
			}
		}
	} // EO While

	if(tok == T_TEXT_DIRECTIVE)
		_process_text_directive(tok);

	
}

int yywrap()
{
	return 1;
}

int main()
{
	int tok;
	while((tok = yylex()) != EOF)
	{
		if(tok == T_DATA_DIRECTIVE) {
			_process_data_directive(tok);
		}
	}

	printf("Symbol Table:\n");
	for (int i = 0; i < 26; ++i) {
		printf("%d  ", symtab[i]);
	}

	printf("Register Table:\n");
	for (int i = 0; i < 26; ++i) {
		printf("%d  ", regtab[i]);
	}
	
}
