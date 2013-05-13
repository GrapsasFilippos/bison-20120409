%{
#include "parser.tab.h"


extern "C" {
  int yylex(void);
}


#if defined(DBML) || defined(DBMA)
  #define DBM(...) printf(__VA_ARGS__);
#else
  #define DBM(...)
#endif


int linesCount = 1;
%}


identifier [a-zA-Z_]+[a-zA-Z_0-9]*
integer [0-9]+
float {integer}"."{integer}


%%
[ \t]+ {}

"\n" { linesCount++; }

"\r" {}

"(" {
  DBM("<(>\n");

  return LPAR;
}

")" {
  DBM("<)>\n");

  return RPAR;
}

"{" {
  DBM("<{>\n");

  return LBRACE;
}

"}" {
  DBM("<}>\n");

  return RBRACE;
}

"[" {
  DBM("<[>\n");

  return LBRACK;
}

"]" {
  DBM("<]>\n");

  return RBRACK;
}

"==" {
  DBM("<==>\n");

  return EQUAL;
}

"=" {
  DBM("<=>\n");

  return ASSIGN;
}

";" {
  DBM("<;>\n");

  return SEMICOLON;
}

"," {
  DBM("<,>\n");

  return COMMA;
}

"." {
  DBM("<.>\n");

  return DOT;
}

"+" {
  DBM("<+>\n");

  return PLUS;
}

"-" {
  DBM("<->\n");

  return MINUS;
}

"*" {
  DBM("<*>\n");

  return TIMES;
}

"/" {
  DBM("</>\n");

  return DIVIDE;
}

"!=" {
  DBM("<!=>\n");

  return NOTEQUAL;
}

"<" {
  DBM("<<>\n");

  return LESS;
}

">" {
  DBM("<>>\n");

  return GREATER;
}

"<=" {
  DBM("<<=>\n");

  return LEQ;
}

">=" {
  DBM("<>=>\n");

  return GEQ;
}

"&&" {
  DBM("<&&>\n");

  return LAND;
}

"||" {
  DBM("<||>\n");

  return LOR;
}

"while" {
  DBM("<while>\n");

  return WHILE;
}

"if" {
  DBM("<if>\n");

  return IF;
}

"else" {
  DBM("<else>\n");

  return ELSE;
}

"int" {
  DBM("<int>\n");

  return TINTEGER;
}

"float" {
  DBM("<float>\n");

  return TFLOAT;
}

{integer} {
  DBM("<int: %s>\n", yytext);

  yylval.num = atof(yytext);

  return INTEGER;
}

{float} {
  DBM("<float: %s>\n", yytext);

  yylval.num = atof(yytext);

  return FLOAT;
}

{identifier} {
  DBM("<identifier: %s>\n", yytext);

  yylval.str = (char *) malloc(strlen(yytext));
  strncpy(yylval.str, yytext, strlen(yytext));

  return IDENTIFIER;
}
