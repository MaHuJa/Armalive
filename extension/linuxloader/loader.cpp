#include <iostream>
#include <fstream>
#include <string>
#include <stdexcept>
#include <cassert>
#include <thread>

#include <dlfcn.h>	// dlopen,dlsym,dlerror,dlclose
#include <unistd.h>	// sleep

typedef void (*rveptr) (char*, int, const char*);

class Rve {
  void* lib;
  rveptr ptr;
public:
  Rve();
  ~Rve();
  void operator() (const char*);
  char buf[4096];
};

Rve::Rve() {
  lib = dlopen ("./armalive.so",RTLD_NOW);
  if (lib == nullptr) {
    std::cerr << "Can't open armalive.so: " << dlerror();
    throw std::exception();
  }
  ptr = reinterpret_cast<rveptr> (dlsym (lib, "RVExtension"));
  if (ptr == nullptr) {
    std::cerr << "Can't find RVExtension: " << dlerror();
    throw std::exception();
  }
}

Rve::~Rve() {
	dlclose(lib);
	lib = nullptr;
	ptr = nullptr;
}

void Rve::operator() (const char* input) {
	ptr(buf,4096,input);
	assert (input[4095]==0);
}

int main() {
	std::ifstream infile("armalive_dump.in");
	std::string s;
	Rve r;
	while (std::getline(infile,s)) {
		r(s.c_str());
	}
	sleep(120);
	r("session");
	std::cout << r.buf;
}
