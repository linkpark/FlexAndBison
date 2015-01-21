#ifndef PARSERNODE_H_
#define PARSERNODE_H_

#include "TableType.h"
#include <string.h>
#include <stdint.h>

struct _ParseNode;

typedef  struct _ParseNode{
    ItemType m_Type;
    
    int64_t m_Value;
    const char* m_pStrValue;
    
    int32_t  m_ChildNumber;
    struct _ParseNode **m_pChildren;
} ParseNode;

typedef struct _ParseResult{
} ParseResult;

#endif
