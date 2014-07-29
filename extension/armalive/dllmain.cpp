// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include "dbthread.h"

std::ofstream logfile("armalive_log");		// Access not synchronized with the debug outputs done same commit.
std::ofstream dumpfile("armalive_dump");	// TODO: Make name dynamic based on current time
int threadcount = 0;
dbthread* db = nullptr;

BOOL APIENTRY DllMain(HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
	)
{
	hModule, lpReserved;	// silence "unreferenced"

	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		logfile << "PROCESS_ATTACH" << std::endl;
		break;
	case DLL_THREAD_ATTACH:
		++threadcount;
		logfile << "THREAD_ATTACH " << threadcount << std::endl;
		break;
	case DLL_THREAD_DETACH:
		--threadcount;
		logfile << "THREAD_DETACH" << threadcount << std::endl;
		break;
	case DLL_PROCESS_DETACH:
		logfile << "PROCESS_DETACH" << std::endl;
		delete db;
		logfile << "Destructed" << std::endl;
		break;
	}
	return TRUE;
}

extern "C" 
{
  __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function); 
};

using namespace std;

void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	if (!db) {
		db = new dbthread();
	}
	dumpfile << function << endl;
	logfile << '.';	// buffered, to say "there's activity".

	string input = function;
	
	dbthread::Task t ([input]()->string {
		db->task_send(input);
		return "";
	});
	db->mainqueue.push(move(t));

	
	// TODO: Proper feedback
	assert(outputSize > 200);
	output[0] = '9';
	output[1] = 0;

}

//*/


