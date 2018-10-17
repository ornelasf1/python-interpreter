mypython: lex.yy.c calc.tab.c calc.tab.h mypython.cpp mypython.h
	g++ calc.tab.c lex.yy.c mypython.cpp mypython.h -o mypython

calc.tab.h:	calc.y
	bison -d  calc.y

lex.yy.c: calc.l calc.tab.h
	flex  calc.l

debug:
	bison -d -t calc.y
	flex -d calc.l
	g++ calc.tab.c lex.yy.c mypython.cpp mypython.h -o mypython

clean:
	rm mypython calc.tab.c lex.yy.c calc.tab.h
