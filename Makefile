all: bison-20120409

CPPFLAGS = -D DBMP

.PHONY: all clean run


bison-20120409: lex.yy.o parser.tab.o identifier.o
	g++ lex.yy.o parser.tab.o identifier.o -o bison-20120409 -lfl

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c -Wall $(CPPFLAGS)

parser.tab.o: parser.tab.c parser.tab.h
	g++ -c parser.tab.c -o parser.tab.o -Wall $(CPPFLAGS)

identifier.o: Identifier.hpp Identifier.cpp
	g++ -c Identifier.cpp -o identifier.o -Wall $(CPPFLAGS)

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

clean:
	-rm bison-20120409 parser.tab.c parser.tab.h lex.yy.c identifier.o parser.tab.o lex.yy.o

run: all
	./bison-20120409 < test.txt