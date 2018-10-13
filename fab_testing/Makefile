mypython: lex.yy.c calc.tab.c calc.tab.h mypython.cpp mypython.h
	g++ calc.tab.c lex.yy.c mypython.cpp mypython.h -o mypython

calc.tab.h:	calc.y
	bison -d calc.y

lex.yy.c: calc.l calc.tab.h
	flex calc.l

clean:
	rm mypython calc.tab.c lex.yy.c calc.tab.h
