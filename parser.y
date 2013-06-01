%{
#define PARSER_Y
#include "parser.y.hpp"
%}


%union {
  char *str;
  int iNum;
  double dNum;
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
%token<dNum> INTEGER
%token<dNum> FLOAT
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
%type<iNum> Type


%%
Procedure:
  DclOn Type Identifier DclOff LPAR ArgumentList RPAR {
    DBM("|\t|\t|Procedure> %s(): %i\n", $3, $2);
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
  DclOn Type Identifier DclOff
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
  DclOn Type Identifier DclOff ASSIGN Computation  {
    DBM("|\t|\t|Initialization> %s: %i\n", $3, $2);
    addIdC( $3, $2 );
  }
;

Declaration:
  DclOn Type Declaration-Identifiers DclOff {
    DBM("|\t|\t|Declaration> %s: %i\n", $3, $2);
    string * str = 0;
    while( (str = qStr.dequeue()) ) {
      addIdS( str, $2 );
      delete( str );
    }
  }
;

DclOn: { declaration = 1; };
DclOff: { declaration = 0; };

Declaration-Identifiers:
  Identifier {
    string * str = new string( $1 );
    qStr.enqueue( str );
  }
  |  Identifier COMMA Declaration-Identifiers {
    string * str = new string( $1 );
    qStr.enqueue( str );
  }
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

    string * str = new string( $1 );
    Identifier * result = 0;
    Identifier * id = new Identifier();
    id->setKey( str );
    result = (Identifier *)bst.search( id );
    if( !declaration && !result) {
      string error( "'" );
      error.append( *str );
      error.append( "' was not declared." );
      yyerror( error.c_str() );
    }
  }
;

Type:
  TINTEGER {
    DBM("|\t|Type> int\n");
    $$ = 1;
  }
  | TFLOAT {
    DBM("|\t|Type> float\n");
    $$ = 2;
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
#include "parser.y.cpp"
