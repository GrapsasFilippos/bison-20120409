#ifndef PARSER_Y_CPP
#define PARSER_Y_CPP


#include "parser.y.hpp"


void yyerror(const char *s) {
  cout << "\nGFError@" << linesCount << ": " << s << endl;
  exit( EXIT_FAILURE );
}


int main() {
    yyparse();

    bst.printTree(1);

    return 0;
}


#endif
