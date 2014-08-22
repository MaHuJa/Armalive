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
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		logfile << "\nShutting down..." << '\n';
		delete db;
		logfile << "Complete." << '\n';
		logfile.flush();
		break;
	}
	return TRUE;
}

extern "C" 
{
  __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function); 
};

using namespace std;

// TODO: oversize splitting
std::string getreference(int ref) {
	auto it = pending_results.find(ref);
	if (it == pending_results.end()) {
		logfile << "No pending result " << ref << '\n';
		logfile.flush();
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

const char* versionstring = "0.4";

void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	--outputSize;
	if (!db) {
		logfile << "armalive a3 extension version " << versionstring << '\n';
		logfile.flush();
		db = new dbthread();
	}
	dumpfile << function << '\n';
	dumpfile.flush();

	string input = function;
	string prefix = input.substr(0, 4);
	if (prefix == "ref ") {
		int ref = atoi(input.substr(4).c_str());
		strncpy(output, getreference(ref).c_str(), outputSize);
	} else if (prefix == "get_") {
		dbthread::Task t(std::bind(&dbthread::task_ask, db, input));
		pending_results[result_count++] = t.get_future();
		db->mainqueue.push(move(t));
	} else if (input.substr(0, 10) == "newmission") {
		db->mainqueue.push(dbthread::Task(std::bind(&dbthread::task_newmission, db, input)));
	} else if (input == "version") {
		strncpy(output, versionstring, outputSize);
	} else if (input == "session") {
		// WARNING! If backlogged, this value may refer to the previous session played.
		_itoa(db->getsession(), output, 10);
	} else {
		db->mainqueue.push(dbthread::Task(std::bind(&dbthread::task_send, db, input)));
	}
}

//*/


