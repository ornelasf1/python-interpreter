run:	main
		./main.exe python_testfile.py
main: mypython.o lex.o
	g++ mypython.o lex.o -o main

mypython.o: mypython.cpp
	g++ -c mypython.cpp

lex.o: lex.cpp
	g++ -c lex.cpp

clean:
	rm *.o main