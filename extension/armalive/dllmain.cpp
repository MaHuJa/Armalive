// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include "dbthread.h"

const char* versionstring = "0.7";
std::ofstream logfile("armalive_log");
std::ofstream dumpfile("armalive_dump");	// TODO: Make name dynamic based on current time
dbthread* db = nullptr;

std::map <int, std::future<std::string>> pending_results;
int result_count = 1;
std::string getreference(int ref) {
	// TODO: oversize splitting
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

#ifdef _WIN32
#define EXPORT __declspec(dllexport) __stdcall
#define DESTRUCTOR
#else
#define EXPORT __attribute__ ((visibility ("default")))
#define DESTRUCTOR __attribute__((destructor))
#endif


void DESTRUCTOR onUnload() 
{
	logfile << "\nShutting down..." << '\n';
	delete db;
	logfile << "Complete." << '\n';
	logfile.flush();
}

#ifdef _WIN32
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
		onUnload();
		break;
	}
	return TRUE;
}
#endif

extern "C" 
{
  void EXPORT RVExtension(char *output, unsigned int outputSize, const char *function); 
};

using namespace std;



void EXPORT RVExtension(char *output, unsigned int outputSize, const char *function)
{
	--outputSize;
	if (!db) {
		logfile << "armalive a3 extension version " << versionstring << '\n';
		logfile.flush();
		db = new dbthread();
	}

	string input = function;
	if (input == "") 
		return;
	string prefix = input.substr(0, 4);

	if (prefix != "ref ") {
		dumpfile << function << '\n';
		dumpfile.flush();
	}

	if (prefix == "ref ") {
		int ref = atoi(input.substr(4).c_str());
		strncpy(output, getreference(ref).c_str(), outputSize);
	} else if (prefix == "get_") {
		dbthread::Task t(std::bind(&dbthread::task_ask, db, input));
		ostringstream s;
		s << "ref " << result_count;
		strncpy(output, s.str().c_str(), min(outputSize, s.str().size()+1));
		pending_results[result_count++] = t.get_future();
		db->mainqueue.push(move(t));
	} else if (prefix == "put_") {
		dbthread::Task t(std::bind(&dbthread::task_send, db, input));
		db->mainqueue.push(move(t));
	} else if (input.substr(0, 10) == "newsession" || input.substr(0,10)=="newmission" ) {
		db->mainqueue.push(dbthread::Task(std::bind(&dbthread::task_newmission, db, input)));
	} else if (input == "version") {
		strncpy(output, versionstring, outputSize);
	} else if (input == "session") {
		// WARNING! If backlogged, this value may refer to the previous session played.
		//std::itoa(db->getsession(), output, 10);
		ostringstream s; 
		s << db->getsession();
		strncpy(output, s.str().c_str(), outputSize);
	} else {
		db->mainqueue.push(dbthread::Task(std::bind(&dbthread::task_send, db, input)));
	}
}

//*/


