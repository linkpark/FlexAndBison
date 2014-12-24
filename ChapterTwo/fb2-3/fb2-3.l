%option noyywrap
%x IFILE

%{
struct bufstack{
    struct bufstack *prev;
    YY_BUFFER_STATE bs;
    int lineno;
    char *filename;
    FILE *f;
} *curbs = 0;

char *curfilename;
int popfile( void );
%}

%%
^"#"[ \t]*include[ \t]*\[\"<]   { BEGIN IFILE; }

<IFILE>[^ \t\n\]+       {   {
                                int c;
                                while((c = input()) && c != '\n') ;
                            }
                            yylineno++;
                            if(!newfile( yytext ))
                                yyterminate();
                            
                            BEGIN INITIAL;
                        }

<IFILE>.|\n           {fprintf(stderr,)}

%%
