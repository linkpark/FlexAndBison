main: main.cpp Calculater.lex.o Calculater.tab.o Node.o
	g++ -g -o main main.cpp Calculater.lex.o Calculater.tab.o Node.o

Calculater.lex.o: Calculater.lex.c Calculater.tab.h
	g++ -g -c Calculater.lex.c

Calculater.tab.o: Calculater.tab.c
	g++ -g -c Calculater.tab.c

Node.o: Node.c Node.h
	g++ -g -c Node.c

Calculater.lex.c: Calculater.l	
	flex -o Calculater.lex.c Calculater.l

Calculater.tab.c Calculater.tab.h: Calculater.y
	bison -d Calculater.y

clean:
	rm -rf main
	rm -rf *.o
	rm -rf *.lex.*
	rm -rf *.tab.*
