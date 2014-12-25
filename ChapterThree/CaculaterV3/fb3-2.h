/*
 * 高级计算器的声明部分
 *
 * */

/* 与词法分析器的接口 */
extern int yylineno;
void yyerror( char *s, ...);
struct AbstractSyntaxTree;

struct Symbol{
    char *name;
    double value;
    struct AbstractSyntaxTree *func;/*函数体*/
    struct SymbolList *syms;/*符号列表*/
};

/*符号列表，作为参数列表*/
struct SymbolList{
    struct Symbol *sym;
    struct SymbolList *next;
};

#define NHASH 9997

struct Symbol symTable[NHASH];

struct Symbol *lookUp(char *);

/*
 * function: newSymList
 * @param sym[in] current node
 * @param next[in] next noe
 *
 * @return struct SymbloList*
 * */
struct SymbolList* newSymbolList(struct SymbolList *sym, struct SymbolList *next);
void deleteSymList(struct SymbolList *symbolList);

/* 节点类型
 * + - * / |
 * 0-7 比较操作符，位编码：04 等于，02 小于，01 大于 
 * M 单目负号
 * L 表达式或者语句列表
 * I If语句
 * W While语句
 * N 符号引用
 * = 赋值
 * S 符号列表
 * F 内置函数调用
 * C 用户函数调用
 * */
enum bifs{
    bSqrt = 1,
    bExp,
    bLog,
    bPrint
};

/*抽象语法树节点定义*/
struct AbstractSyntaxTree{
    int nodeType;
    struct AbstractSyntaxTree *left;
    struct AbstractSyntaxTree *right;
};

struct FunctionCall{
    int nodeType;
    struct AbstractSyntaxTree *left;
    struct Symbol *symbol;  
};

struct UserFunctionCall{
    int nodeType;
    struct AbstractSyntaxTree *left;
    struct Symbol *symbol;
};

struct Flow {
    int nodeType;
    struct AbstractSyntaxTree *condition;
    struct AbstractSyntaxTree *thenBranch;
    struct AbstractSyntaxTree *elseBranch;
};

struct NumberValue{
    int nodeType;
    double number;
};

struct SymbolReference{
    int nodeType;
    struct Symbol *symbol;
};

struct SymbolAsgn{
    int nodeType;
    struct Symbol *symbol;
    struct AbstractSyntaxTree *value;
};

/*构造抽象语法树*/
struct AbstractSyntaxTree* newAbstractSyntaxTree( int nodeType, 
        struct AbstractSyntaxTree *l, struct AbstractSyntaxTree *r);

struct AbstractSyntaxTree* newCompare( int compareType, 
        struct AbstractSyntaxTree *l, struct AbstractSyntaxTree *r);

struct AbstractSyntaxTree* newFunctionCall( int funcType, 
        struct AbstractSyntaxTree *l, struct AbstractSyntaxTree *r);

struct AbstractSyntaxTree* newUserFunctionCall( struct Symbol *s, 
        struct AbstractSyntaxTree* l );

struct AbstractSyntaxTree* newSymbolReference( struct Symbol *s);

struct AbstractSyntaxTree* newSymbolAsgn( struct Symbol *symbol, 
        struct AbstractSyntaxTree *value);

struct AbstractSyntaxTree* newNumberValue( double d );

struct AbstractSyntaxTree* newFlow( int nodeType, struct AbstractSyntaxTree *condition, 
        struct AbstractSyntaxTree *thenBranch, struct AbstractSyntaxTree *elseBranch );

/* 定义函数 */
void doDefine(struct Symbol *name, struct symbolList *syms , 
        struct AbstractSyntaxTree *stmts);

/* 计算抽象语法树 */
double eval( struct AbstractSyntaxTree* );

/* 删除和释放抽象语法树 */
void treeFree( struct AbstractSyntaxTree* );

/*与词法分析器的接口*/
extern int yylineno;
void yyerror(char *s, ...);

