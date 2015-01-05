fb3-1: fb3-1.l fb3-1.y fb3-1.h fb3-1.lex.o
	gcc -g -o $@ fb3-1.tab.c fb3-1.lex.c fb3-1.lex.h fb3-1funcs.c -lfl

fb3-1.lex.o: fb3-1.lex.c
	gcc -g -c fb3-1.lex.c

fb3-1.lex.c:
	bison -d fb3-1.y
	flex -o fb3-1.lex.c fb3-1.l

clean:
	rm -rf fb3-1
	rm -rf fb3-1.lex.*
	rm -rf fb3-1.tab.*

