// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include "dbthread.h"

std::ofstream logfile("armalive_log");
std::ofstream dumpfile("armalive_dump");	// TODO: Make name dynamic based on current time
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
		//logfile << "PROCESS_ATTACH" << std::endl;
		break;
	case DLL_THREAD_ATTACH:
		//logfile << "THREAD_ATTACH" << std::endl;
		break;
	case DLL_THREAD_DETACH:
		//logfile << "THREAD_DETACH" << std::endl;
		break;
	case DLL_PROCESS_DETACH:
		//logfile << "PROCESS_DETACH" << std::endl;
		delete db;
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
		logfile << "armalive a3 extension version 0.1";
		db = new dbthread();
	}
	dumpfile << function << endl;

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


