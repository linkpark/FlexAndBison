#ifndef NODE_H_
#define NODE_H_

#include <stdarg.h>

typedef enum NodeType{
    T_NUMBER,
    OP_ADD,
    OP_SUB,
    OP_MUL,
    OP_DIV
} NodeType;

typedef struct _node{
    NodeType type;
    int value;
    
    int childNumber;
    struct _node **children;
} Node;

typedef struct _ResultPlan{
    void *yyscanInfo;
    Node *resultTree;

    int yycolumn;
    int yylineno;
} ResultPlan;

#ifdef __cplusplus
extern "C" {
#endif

extern struct _node* newNode(NodeType type, int childNumber );

extern void printTree( Node *p , int level);

extern struct _node* mallocNonTerminalNode( NodeType type, int num, ...);

#ifdef __cplusplus
}
#endif

#endif
