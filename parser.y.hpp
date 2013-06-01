#ifndef PARSER_Y_HPP
#define PARSER_Y_HPP


#include <stdio.h>
#include <cstdlib>
#include <iostream>
#include <string>


#if defined(DBMP) || defined(DBMA)
  #define DBM(...) printf(__VA_ARGS__);
#else
  #define DBM(...)
#endif


#include "parser.tab.h"
#include "gfbinarysearchtree.hpp"
#include "gfqueue.hpp"
#include "Identifier.hpp"


extern "C" {
  int yylex(void);
  void yyerror(const char *s);
  int yyparse (void);
}
extern int linesCount;


GFBinarySearchTree< GFBinarySearchTreeDataContainer< string * > * > bst;
GFQueue< string * > qStr;
bool declaration = 0;

void addIdS( string * str, int type ) {
    string * cpdStr = new string( *str );
    Identifier * id = new Identifier();
    id->setKey( cpdStr );
    id->setType( type );
    if( !bst.add( id ) ) {
        delete( cpdStr );
        delete( id );
        string error = "Redeclaration of ";
        error.append( *str );
        yyerror( error.c_str() );
    }
}

void addIdC( char * str, int type ) {
    string * cpd = new string( str );
    addIdS( cpd, type );
    delete( cpd );
}


#endif
