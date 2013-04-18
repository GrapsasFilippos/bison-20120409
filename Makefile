all: 20120409

lex.yy.c : lexer.l parser.tab.h
	flex lexer.l

parser.tab.c parser.tab.h : parser.y
	bison -d parser.y

20120409 : lex.yy.c parser.tab.c parser.tab.h
	gcc lex.yy.c parser.tab.c -o 20120409 -lfl

clean:
	rm 20120409 parser.tab.c parser.tab.h lex.yy.c