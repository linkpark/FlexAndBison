/*
* sql 子集语法分析器
**/
%option reentrant bison-bridge bison-locations
%option noyywrap nodefault yylineno case-insensitive
%{
#include "SqlParser.tab.h"
#include "ParserNode.h"
#include <stdarg.h>
#include <string.h>

int oldState;
%}

%x COMMENT
%s BTWMODE

%%
ADD               { return ADD; }
ALTER             { return ALTER; }
AND               { return AND; }
ANY               { return ANY; }
ALL               { return ALL; }
AS                { return AS; }
ASC               { return ASC; }
BEGIN             { return BEGI; }
BETWEEN           { return BETWEEN; }
BIGINT            { return BIGINT; }
BINARY            { return BINARY; }
BOOL(EAN)?       { return BOOLEAN; }
BOTH              { return BOTH; }
BY                { return BY; }
CASCADE           { return CASCADE; }
CASE              { return CASE; }
CHAR(ACTER)?      { return CHARACTER; }
CLUSTER           { return CLUSTER; }
COLUMN            { return COLUMN; }
COLUMNS           { return COLUMNS; }
COMMIT            { return COMMIT; }
CONSISTENT        { return CONSISTENT; }
CREATE            { return CREATE; }
CREATETIME        { return CREATETIME; }
CURRENT_USER      { return CURRENT_USER; }
DATE              { return DATE; }
DATETIME          { return DATETIME; }
DEALLOCATE        { return DEALLOCATE; }
DEC(IMAL)?        { return DECIMAL; }
DEFAULT           { return DEFAULT; }
DELETE            { return DELETE; }
DESC              { return DESC; }
DESCRIBE          { return DESCRIBE; }
DISTINCT          { return DISTINCT; }
DOUBLE            { return DOUBLE; }
DROP              { return DROP; }
DUAL              { return DUAL; }
ELSE              { return ELSE; }
END               { return END; }
ERROR             { return ERROR; }
EXCEPT            { return EXCEPT; }
EXECUTE           { return EXECUTE; }
EXISTS            { return EXISTS; }
EXPLAIN           { return EXPLAIN; }
FLOAT             { return FLOAT; }
FLOAT4            { return FLOAT; }
FLOAT8            { return DOUBLE; }
FOR               { return FOR; }
FROM              { return FROM; }
FULL              { return FULL; }
GRANT             { return GRANT; }
GROUP             { return GROUP; }
GLOBAL            { return GLOBAL; }
HAVING            { return HAVING; }
IDENTIFIED        { return IDENTIFIED; }
IF                { return IF; }
IN                { return IN; }
INNER             { return INNER; }
INT               { return INTEGER; }
INTEGER           { return INTEGER; }
INTERSECT         { return INTERSECT; }
INSERT            { return INSERT; }
INTO              { return INTO; }
IS                { return IS; }
JOIN              { return JOIN; }
KEY               { return KEY; }
LEADING           { return LEADING; }
LEFT              { return LEFT; }
LIMIT             { return LIMIT; }
LIKE              { return LIKE; }
LOCAL             { return LOCAL; }
LOCKED            { return LOCKED; }
MEDIUMINT         { return MEDIUMINT; }
MEMORY            { return MEMORY; }
MOD               { return MOD; }
MODIFYTIME        { return MODIFYTIME; }
NOT               { return NOT; }
NUMERIC           { return NUMERIC; }
OFFSET            { return OFFSET; }
ON                { return ON; }
OPTION            { return OPTION; }
OR                { return OR; }
ORDER             { return ORDER; }
OUTER             { return OUTER; }
COMMENT           { return COMMENT; }
PARAMETERS        { return PARAMETERS; }
PASSWORD          { return PASSWORD; }
PRECISION         { return PRECISION; }
PREPARE           { return PREPARE; }
PRIMARY           { return PRIMARY; }
REAL              { return REAL; }
RENAME            { return RENAME; }
REPLACE           { return REPLACE; }
RESTRICT          { return RESTRICT; }
REVOKE            { return REVOKE; }
RIGHT             { return RIGHT; }
ROLLBACK          { return ROLLBACK; }
PRIVILEGES        { return PRIVILEGES; }
SELECT            { return SELECT; }
SCHEMA            { return SCHEMA; }
PROCESSLIST       { return PROCESSLIST; }
SCOPE             { return SCOPE; }
SESSION           { return SESSION; }
SET               { return SET; }
SHOW              { return SHOW; }
SMALLINT          { return SMALLINT; }
SNAPSHOT          { return SNAPSHOT; }
SPFILE            { return SPFILE; }
START             { return START; }
STATIC            { return STATIC; }
WEAK              { return WEAK;   }
STRONG            { return STRONG; }
SYSTEM            { return SYSTEM; }
TABLE             { return TABLE; }
TABLES            { return TABLES; }
THEN              { return THEN; }
TIME              { return TIME; }
TIMESTAMP         { return TIMESTAMP; }
TINYINT           { return TINYINT; }
TO                { return TO; }
TRAILING          { return TRAILING; }
TRANSACTION       { return TRANSACTION; }
UNION             { return UNION; }
UPDATE            { return UPDATE; }
USER              { return USER; }
USING             { return USING; }
VALUES            { return VALUES; }
VARBINARY         { return VARBINARY; }
VARCHAR(ACTER)?   { return VARCHAR; }
WHERE             { return WHERE; }
WHEN              { return WHEN; }
WITH              { return WITH; }
WORK              { return WORK; }
KILL              { return KILL; }
QUERY             { return QUERY; }
CONNECTION        { return CONNECTION; }
FROZEN            { return FROZEN;}

-?[0-9]+ {
/*parse number*/
    yylval.intval = atoi(yytext);
    return INTNUM;
 }

-?[0-9]+"."[0-9]* |
-?"."[0-9]+ |
-?[0-9]+E[-+]?[0-9]+ |
-?[0-9]+"."[0-9]*E[-+]?[0-9]+ |
-?"."[0-9]+E[-+]?[0-9]+ {
    yylval.floatval = atof(yytext);
    return APPROXNUM;
}

TRUE {
    yylval.intval = 1;
    return BOOL;
}

UNKNOWN {
    yylval.intval = -1;
    return BOOL;
}

FALSE {
    yylval.intval = 0;
    return BOOL;
}

'(\\.|''|[^'\n])*' |
\"(\\.|\"\"|[^"\n])*\" {
    yylval.strval = strdup( yytext );
    return STRING;
}

'(\\.|[^'\n])*$ {
    yyerror("Unterminated string %s", yytext );
}

\"(\\.|[^"\n])*$ {
    yyerror("Unterminated string %s", yytext );
}

 /* TODO 十六进制字符串 */

 /* TODO 二进制字符串 */


 /* 操作符 */
[-+&~|^/%*(),.;!] {
    return yytext[0];
}

"&&" { return ANDOP; }
"||" { return OR; }

"=" { yylval.subtok = 4; return COMPARISON; }
"<=>" { yylval.subtok = 12; return COMPARISON; }
">=" { yylval.subtok = 6; return COMPARISON; }
">" { yylval.subtok = 2; return COMPARISON; }
"<=" { yylval.subtok = 5; return COMPARISON; }
"<" { yylval.subtok = 1; return COMPARISON; }
"!=" |
"<>" { yylval.subtok = 3; return COMPARISON; }
"<<" { yylval.subtok = 1; return SHIFT; }
">>" { yylval.subtok = 2; return SHIFT; }

":=" { return ASSIGN; }
 /* 函数 */

SUBSTR(ING)?/"(" { return FSUBSTRING; }
TRIM/"(" { return FTRIM; }
DATE_ADD/"(" { return FDATE_ADD; }
DATE_SUB/"(" { return FDATE_SUB; }

COUNT {
    int c = input();
    unput(c);
    
    if( c == '(' )
        return FCOUNT;
    yylval.strval = strdup( yytext );
    return NAME;
}

 /* 名字 */
[A-Za-z][A-Za-z0-9_]* {
    yylval.strval = strdup(yytext);
    return NAME;
}

`[^`/\\.\n]+` {
    yylval.strval = strdup( yytext+1 );
    yylval.strval[yyleng-2] = 0;
    return NAME;
}

`[^`\n]*$ {
    yyerror("unterminated quoted name %s", yytext);
}

 /*用户变量*/
@[0-9a-z_.$]+ |
@\"[^"\n]+\" |
@`[^`\n]+` |
@'[^'\n]+' {
    yylval.strval = strdup( yytext+1 );
    return USERVAR;
}

@\"[^"\n]*$ {
    yyerror("unterminated quoted user variable %s", yytext );
}

@`[^`\n]*$ {
    yyerror("unterminated quoted user variable %s", yytext );
}

@'[^'=\n]*$ {
    yyerror("unterminated quoted user variable %s", yytext );
}

 /* 注释 */
#.* ;
"--"[ \t].* ;

"/*"   { oldstate = YY_START; BEGIN COMMENT; }
<COMMENT>"*/" { BEGIN oldstate;}
<COMMENT>.|\n ;
<COMMENT><<EOF>> { yyerror("unclosed comment"); }

 /*其他 */

[ \t\n] /* whitedpace */
. { yyerror("mystery character '%c'", *yytext); }

%%

