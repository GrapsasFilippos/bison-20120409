%{
#include "parser.tab.h"

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
  printf("<(>\n");

  return LPAR;
}

")" {
  printf("<)>\n");

  return RPAR;
}

"{" {
  printf("<{>\n");

  return LBRACE;
}

"}" {
  printf("<}>\n");

  return RBRACE;
}

"[" {
  printf("<[>\n");

  return LBRACK;
}

"]" {
  printf("<]>\n");

  return RBRACK;
}

"==" {
  printf("<==>\n");

  return EQUAL;
}

"=" {
  printf("<=>\n");

  return ASSIGN;
}

";" {
  printf("<;>\n");

  return SEMICOLON;
}

"," {
  printf("<,>\n");

  return COMMA;
}

"." {
  printf("<.>\n");

  return DOT;
}

"+" {
  printf("<+>\n");

  return PLUS;
}

"-" {
  printf("<->\n");

  return MINUS;
}

"*" {
  printf("<*>\n");

  return TIMES;
}

"/" {
  printf("</>\n");

  return DIVIDE;
}

"!=" {
  printf("<!=>\n");

  return NOTEQUAL;
}

"<" {
  printf("<<>\n");

  return LESS;
}

">" {
  printf("<>>\n");

  return GREATER;
}

"<=" {
  printf("<<=>\n");

  return LEQ;
}

">=" {
  printf("<>=>\n");

  return GEQ;
}

"&&" {
  printf("<&&>\n");

  return LAND;
}

"||" {
  printf("<||>\n");

  return LOR;
}

"while" {
  printf("<while>\n");

  return WHILE;
}

"if" {
  printf("<if>\n");

  return IF;
}

"else" {
  printf("<else>\n");

  return ELSE;
}

"int" {
  printf("<int>\n");

  return TINTEGER;
}

"float" {
  printf("<float>\n");

  return TFLOAT;
}

{integer} {
  printf("<int: %s>\n", yytext);

  yylval.num = atof(yytext);

  return INTEGER;
}

{float} {
  printf("<float: %s>\n", yytext);

  yylval.num = atof(yytext);

  return FLOAT;
}

{identifier} {
  printf("<identifier: %s>\n", yytext);

  yylval.str = malloc(strlen(yytext));
  strncpy(yylval.str, yytext, strlen(yytext));

  return IDENTIFIER;
}
