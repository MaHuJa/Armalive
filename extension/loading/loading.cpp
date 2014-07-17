// loading.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

typedef void (__stdcall *rve) (char*, int, const char*);

int main(int argc, char* argv[])
{
	HMODULE m = LoadLibraryA(
#ifdef _DEBUG
		"..\\Debug\\armalive.dll"
#else
		"..\\Release\\armalive.dll"
#endif
	);
	if (!m) { 
		std::cout << "LoadLibraryA failed\n";	
		return 1; 
	}
	rve foo = reinterpret_cast<rve>(GetProcAddress(m,"_RVExtension@12"));
	if (!foo) { 
		std::cout << "No RVExtension()\n"; 
		return 2; 
	}
	auto call = [foo](const char* str) {
		char buf[256];
		foo(buf, 256, str);
	};

	std::ifstream in("armalive_log.in");
	std::string s;
	int count = 0;
	while (in) {
		std::getline(in, s);
		call(s.c_str());
		count++;
	}
	std::cout << count;
	__asm nop;
	// Assume my ping time will never exceed 200.
	std::this_thread::sleep_for(std::chrono::milliseconds(200*count+1000));

	// TODO: File compare
	return 0;
}

