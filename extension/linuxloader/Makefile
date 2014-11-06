all: loader armalive.so

armalive.so:
	ln -s ../armalive/armalive.so armalive.so

loader:
	g++ -std=c++11 -m32 loader.cpp -ldl -o loader -pthread

clean:
	rm -f loader armalive.so

