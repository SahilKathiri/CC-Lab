#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUCKETS 5

struct node_t {
	char id[10];
	int data;
	struct node_t *next;
};


struct node_t *hash_table[MAX_BUCKETS];

int hashFunc(char id[])
{
	int sum =0;
	while (*id) { sum += *id++; }
	return sum % MAX_BUCKETS;
}

void _insertSymbolTable(struct node_t *ht[], char id[], int val)
{
	int index = hashFunc(id);
	struct node_t *new_node;
	new_node = (struct node_t *)malloc(sizeof(struct node_t));
	strcpy(new_node->id, id);
	new_node->data = val;
	new_node->next = NULL;
	if (ht[index] != NULL) {
		new_node->next = ht[index];
	}
	ht[index] = new_node;
}
void insertSymbolTable(char id[], int val)
{
	_insertSymbolTable(hash_table, id, val);
}


int _searchSymbolTable(struct node_t *ht[], char id[],  int *val)
{
	int index = hashFunc(id);
	struct node_t *tmp;

	for (tmp = ht[index]; tmp; tmp = tmp->next) {
		if (strcmp(tmp->id, id) == 0 ) {
			*val = tmp->data; 
			return 1;
		}
	}
	return 0;
}

int searchSymbolTable(char id[], int *val)
{
	return _searchSymbolTable(hash_table, id, val);
}

void _printSymbolTable(struct node_t *ht[])
{
	int i;
	struct node_t *tmp;

	for (i = 0; i < MAX_BUCKETS; i++) {
		printf ( "i=%d: ", i);
		for (tmp = ht[i]; tmp; tmp = tmp->next) {
			printf ( "%d ", tmp->data);
		}
		printf("\n");
	}
}

void printSymbolTable() { _printSymbolTable(hash_table); }

void initSymbolTable()
{	
	int i;
	for (i = 0; i < MAX_BUCKETS; i++) {
		hash_table[i] = NULL;
	}
}

#ifdef MAIN
main()
{
	int a[] = { 26, 37, 59, 76, 65, 86 };
	int b[] =  { 26, 59, 10, 86, 0 };
	int i;

	struct node_t *hash_table[MAX_BUCKETS];
	
	for (i = 0; i < MAX_BUCKETS; i++) {
		hash_table[i] = NULL;
	}
	
	for (i = 0; i < 6; i++ ) {
		insert(hash_table, a[i]);
	}
	
	print(hash_table);
	
	for (i = 0; i < 5; i++ ) {
		int found = search(hash_table, b[i]);
		if ( found == 1) {
			printf ( "Found element %d\n", b[i] );
		} else {
			printf ( "Not Found element %d\n", b[i] );
		}
	}
}
#endif
