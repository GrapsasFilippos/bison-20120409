%{
#include <stdio.h>
#include <string.h>

extern int linesCount;
%}


%union {
  char *str;
  double num;
}

%token<str> IDENTIFIER
%token LPAR
%token RPAR
%token LBRACE
%token RBRACE
%token LBRACK
%token RBRACK
%token EQUAL
%token ASSIGN
%token SEMICOLON
%token COMMA
%token DOT
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token NOTEQUAL
%token LESS
%token GREATER
%token LEQ
%token GEQ
%token LAND
%token LOR
%token WHILE
%token IF
%token ELSE
%token<num> INTEGER
%token<num> FLOAT
%token TINTEGER
%token TFLOAT

%left LOR
%left LAND
%left EQUAL NOTEQUAL
%left LESS LEQ GREATER GEQ
%left PLUS MINUS
%left TIMES DIVIDE

%type<str> Declaration-Identifiers
%type<str> Identifier
%type<str> Type


%%
Procedure:
  Type Identifier LPAR ArgumentList RPAR {
    printf("|\t|\t|Procedure> %s(): %s\n", $2, $1);
  }
  Block
;

Block:
  LBRACE PhraseList RBRACE
;

ArgumentList:
  | Arguments
;

Arguments:
  Argument
  | Argument COMMA Arguments
;

Argument:
  Type Identifier
;

PhraseList:
  | Phrases
;

Phrases:
  Phrase SEMICOLON
  | Phrase SEMICOLON Phrases
  | Iteration
  | Iteration Phrases
  | Conditional
  | Conditional Phrases
;

Phrase:
  Initialization
  | Declaration
  | Assignment
;

Iteration:
  WHILE LPAR Computation RPAR {
    printf("|\t|\t|While>\n");
  }
  Block
;

Conditional:
  IF LPAR Computation RPAR {
    printf("|\t|\t|Conditional>\n");
  }
  Block Conditional-Else
;

Conditional-Else:
  | ELSE Block
;

Initialization:
  Type Identifier ASSIGN Computation  {
    printf("|\t|\t|Initialization> %s: %s\n", $2, $1);
  }
;

Declaration:
  Type Declaration-Identifiers {
    printf("|\t|\t|Declaration> %s: %s\n", $2, $1);
  }
;

Declaration-Identifiers:
  Identifier
  |  Identifier COMMA Declaration-Identifiers
;

Assignment:
  Identifier ASSIGN Computation {
    printf("|\t|\t|Assignment>\n");
  }
;

Computation:
  Number
  | Identifier
  | LPAR Computation RPAR
  | Computation PLUS Computation
  | Computation MINUS Computation
  | Computation TIMES Computation
  | Computation DIVIDE Computation
  | Computation LOR Computation
  | Computation LAND Computation
  | Computation EQUAL Computation
  | Computation NOTEQUAL Computation
  | Computation LESS Computation
  | Computation LEQ Computation
  | Computation GREATER Computation
  | Computation GEQ Computation
;

Identifier:
  IDENTIFIER {
    printf("|\t|Identifier> %s\n", $1);
  }
;

Type:
  TINTEGER {
    printf("|\t|Type> int\n");
    $$ = "int";
  }
  | TFLOAT {
    printf("|\t|Type> float\n");
    $$ = "float";
  }
;

Number:
  INTEGER {
    printf("|\t|Number> %f\n", $1);
  }
  | FLOAT {
    printf("|\t|Number> %f\n", $1);
  }
;


%%
int yyerror(char *s) {
  printf("\nGFError@%i: %s\n", linesCount, s);
  return -1;
}

int main() {
  yyparse();
  return 0;
}
