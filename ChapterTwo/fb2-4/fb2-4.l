%option noyywrap nodefault yylineno case-insensitive

/*符号表*/
%{
    struct symbol{
        char *name;
        struct ref *reflist;
    };

    struct ref{
        struct ref *next;
        char *filename;
        int flags;
        int lineno;
    };

    #define NHASH 9997
    struct symbol symtab[ NHASH ];

    struct symbol *lookup( char * );
    void addref(int , char* , char*, int );

    char *curfilename; /*当前输入文件的名称*/
%}

%%
a |
an |
and |
are |
as |
at |
be |
but |
for |
in |
is |
it |
of |
on |
or |
that |
the |
this |
to         /* 忽略 */

[a-z]+(\'(s|t))?      {addref(yylineno,curfilename,yytext,0);}
.|\n      /*忽略其他东西*/
%%

main(int argc,char **argv){
    int i;
    
    if( argc < 2 ){
        curfilename = "(stdin)";
        yylineno = 1;
        yylex();
    }else{
        for(i = 1 ; i < argc ; i++ ){
            FILE *f = fopen(argv[i], "r");
            
            if(!f){
                perror(argv[1]);
                return (1);
            }
            curfilename = argv[i];
            
            yyrestart(f);
            yylineno = 1;
            yylex();
            fclose(f);
        }
    }

    printrefs();
}

static unsigned symhash(char *sym){
    unsigned int hash = 0;
    unsigned c;

    while( c = *sym++){
        hash = hash*9 ^c;
    }
    
    return hash;
}

struct symbol* lookup(char *sym){
    struct symbol *sp = &symtab[ symhash(sym) % NHASH ];
    int scount = NHASH;

    while( --scount >= 0){
        if( sp->name && !strcmp(sp->name, sym))
            return sp;
    
        if( !sp->name ){
            sp->name = strdup(sym);
            sp->reflist = 0;
            return sp;
        }

        if( ++sp >= symtab+NHASH )
            sp = symtab;
    }
    
    fputs("symbol table overflow\n",stderr);
    abort();
}

void addref( int lineno, char *filename, char *word, int flags){
    struct ref *r;
    struct symbol *sp = lookup(word);

    /*不用复制相同的文件*/
    if( sp->reflist &&
        sp->reflist->lineno == lineno &&
        sp->reflist->filename == filename)
    return;

    r = malloc(sizeof(struct ref));

    if(!r){
        fputs("out of space\n",stderr);
        abort();
    }
    
    r->next = sp->reflist;
    r->filename = filename;
    r->lineno = lineno;
    r->flags = flags;
    sp->reflist = r;
}

static int symcompare(const void *xa, const void *xb){
    const struct symbol *a = xa;
    const struct symbol *b = xb;
    
    if( !a->name ){
        if( !b->name )
            return 0;

        return 1;
    }
    
    if(!b->name)
        return -1;
    
    return strcmp(a->name, b->name);
}

