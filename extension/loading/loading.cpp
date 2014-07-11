// loading.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

typedef void (__stdcall *rve) (char*, int, const char*);

int main(int argc, char* argv[])
{
	HMODULE m = LoadLibraryA(
#ifdef _DEBUG
		"..\\Debug\\bstats.dll"
#else
		"..\\Release\\bstats.dll"
#endif
	);
	if (!m) { std::cout << "LoadLibraryA failed\n";	return 1; }
	rve foo = reinterpret_cast<rve>(GetProcAddress(m,"_RVExtension@12"));
	if (!foo) { std::cout << "No RVExtension()\n"; return 2; }
	auto call = [foo](const char* str) {
		char buf[256];
		foo(buf, 256, str);
	};
	call("newmission1;HELLO WORLD!!!11one;FantasyWorld");
	// server.newplayer1(sessionid integer, playerid text, playerside text, jointime integer, playername_p text)
	call("newplayer1;AAA;west;0;Testplayer A");
	call("newplayer1;BBB;east;0;Testplayer B");
	call("newplayer1;CCC;west;10;Testplayer C");
	call("inf_killed_inf1;AAA;BBB;15;testweapon1;10;[10,20,0];[20,10,0]");
	call("inf_killed_inf1;AAA;BBB;15;testweapon1;10;[10,20,0];[20,10,0]");
	call("inf_killed_inf1;BBB;CCC;15;testweapon2;10;[10,20,0];[20,10,0]");
	call("inf_killed_inf1;CCC;AAA;15;testweapon1;10;[10,20,0];[20,10,0]");
	call("inf_killed_inf1;AAA;BBB;15;testweapon2;10;[10,20,0];[20,10,0]");

	__asm nop;
	std::this_thread::sleep_for(std::chrono::seconds(10));
	return 0;
}

