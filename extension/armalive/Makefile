PGLIBPATH=/usr/lib/i386-linux-gnu/
PGINCLUDEPATH=/usr/include/postgresql/
CFLAGS=-std=c++11 -fPIC -m32 -Wall -c -I$(PGINCLUDEPATH)
LDFLAGS=-shared -m32 -lpq -L$(PGLIBPATH)
CC=g++

all: armalive.so

armalive.so: dbthread.o dllmain.o pg.o
	$(CC) $(LDFLAGS) $^ -o armalive.so

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@
	
clean:
	rm -f armalive.so *.o

# $(MAKE) -C path/to/dir target

