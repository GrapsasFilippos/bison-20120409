%{
#include <stdio.h>
#include <string.h>


extern "C" {
  int yylex(void);
  void yyerror(const char *s);
}
extern int linesCount;


#if defined(DBMP) || defined(DBMA)
  #define DBM(...) printf(__VA_ARGS__);
#else
  #define DBM(...)
#endif
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
    DBM("|\t|\t|Procedure> %s(): %s\n", $2, $1);
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
    DBM("|\t|\t|While>\n");
  }
  Block
;

Conditional:
  IF LPAR Computation RPAR {
    DBM("|\t|\t|Conditional>\n");
  }
  Block Conditional-Else
;

Conditional-Else:
  | ELSE Block
;

Initialization:
  Type Identifier ASSIGN Computation  {
    DBM("|\t|\t|Initialization> %s: %s\n", $2, $1);
  }
;

Declaration:
  Type Declaration-Identifiers {
    DBM("|\t|\t|Declaration> %s: %s\n", $2, $1);
  }
;

Declaration-Identifiers:
  Identifier
  |  Identifier COMMA Declaration-Identifiers
;

Assignment:
  Identifier ASSIGN Computation {
    DBM("|\t|\t|Assignment>\n");
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
    DBM("|\t|Identifier> %s\n", $1);
  }
;

Type:
  TINTEGER {
    DBM("|\t|Type> int\n");
    $$ = (char *) "int";
  }
  | TFLOAT {
    DBM("|\t|Type> float\n");
    $$ = (char *) "float";
  }
;

Number:
  INTEGER {
    DBM("|\t|Number> %f\n", $1);
  }
  | FLOAT {
    DBM("|\t|Number> %f\n", $1);
  }
;


%%
void yyerror(const char *s) {
  printf("\nGFError@%i: %s\n", linesCount, s);
}

int main() {
  yyparse();
  return 0;
}
