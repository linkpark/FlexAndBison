#include "Node.h"
#include <stdio.h>
#include <stdlib.h>

struct _node* newNode( NodeType type, int childNumber){
    Node *node = (Node * )malloc( sizeof( struct _node) );

    if( NULL == node )
        perror("node malloc error!\n");

    node->type = type;
    node->childNumber = childNumber;
    if(childNumber > 0){
        node->children = 
            (struct _node **)malloc( sizeof(Node*) * childNumber);
    }

    return node;
}

void printTree( Node *p , int level){
    int i;
    for( i = 0 ; i < level ; i++){
        printf("    ");
    }
    
    printf( "|%d %d\n", p->type, p->value);

    for( i = 0 ; i < p->childNumber ; ++i ){
        printTree( p->children[i], level + 1);
    }
}

struct _node* mallocNonTerminalNode( NodeType type, int num, ... ){
    va_list va;
    int i;
    
    Node *node = newNode( type, num );
    if( NULL != node){
        va_start( va , num );
        for( i = 0 ; i < num; ++i){
            node->children[i] = va_arg(va , Node*);
        } 
        va_end( va );
    } 

    return node;
}

