#include <iostream>
#include <stdlib.h>
#include "Node.h"

using namespace std;

int main(){
    ResultPlan *p ;
    p = (ResultPlan *)malloc( sizeof(struct _ResultPlan ));
    
    parseStmt( p, "1+1+1", 3);
    
    printTree( p->resultTree ,0 );    
}
