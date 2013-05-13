all: bison-20120409

CPPFLAGS = -D DBMP

.PHONY: all clean


bison-20120409: lex.yy.o parser.tab.o
	g++ lex.yy.o parser.tab.o -o bison-20120409 -lfl

lex.yy.o: lex.yy.c
	g++ lex.yy.c -Wall -c $(CPPFLAGS)

parser.tab.o: parser.tab.c parser.tab.h
	g++ parser.tab.c -Wall -c $(CPPFLAGS)

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

clean:
	-rm bison-20120409 parser.tab.c parser.tab.h lex.yy.c parser.tab.o lex.yy.o
