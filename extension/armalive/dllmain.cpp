// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include "dbthread.h"

std::ofstream logfile("armalive_log");
std::ofstream dumpfile("armalive_dump");	// TODO: Make name dynamic based on current time
dbthread* db = nullptr;

std::map <int, std::future<std::string>> pending_results;
int result_count = 1;

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
		logfile << "\nShutting down..." << std::endl;
		delete db;
		logfile << "Complete." << std::endl;
		break;
	}
	return TRUE;
}

extern "C" 
{
  __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function); 
};

using namespace std;

std::string getreference(int ref) {
	auto it = pending_results.find(ref);
	if (it == pending_results.end()) {
		logfile << "No pending result " << ref << std::endl;
		return "error";
	}
	auto status = it->second.wait_for(std::chrono::seconds(0));
	if (status == std::future_status::ready)  {
		auto ret = it->second.get();
		pending_results.erase(it);
		return ret;
	}
	return "";
}


void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	--outputSize;
	if (!db) {
		logfile << "armalive a3 extension version 0.1";
		db = new dbthread();
	}
	dumpfile << function << endl;

	string input = function;
	string prefix = input.substr(0, 4);
	if (prefix == "ref ") {
		int ref = atoi(input.substr(4).c_str());
		strncpy(output, getreference(ref).c_str(), outputSize);
	} else if (prefix == "get_") {
		dbthread::Task t(std::bind(&dbthread::task_ask, db, input));
		pending_results[result_count++] = t.get_future();
		db->mainqueue.push(move(t));
	} else {
		db->mainqueue.push(dbthread::Task(std::bind(&dbthread::task_send, db, input)));
	}
}

//*/


