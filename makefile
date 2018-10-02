main: mypython.o lex.o

mypython.o: mypython.cpp
	g++ -c mypython.cpp

lex.o: lex.cpp
	g++ -c lex.cpp

clean:
	rm *.o main
