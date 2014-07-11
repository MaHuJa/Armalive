#pragma once
#include "pg.h"

class dbthread { 
	typedef std::string string;
	pg::Connection conn;
	std::thread my_thread;
	std::deque<string> q; std::mutex qm;
	typedef std::lock_guard<std::mutex> guard;

	long int sessionid;
	bool running;
	void run();
	void connectloop();

	typedef std::vector<string> paramlist;
	paramlist split(string);
	string grab_cmd();
	void send_error(string msg, string input);
public:
	dbthread() : my_thread(&dbthread::run,this), running(true), sessionid(0) {}
	~dbthread();
	bool is_online();

	// A new command has arrived, add to the queue here.
	// This function is designed to be called from some other thread than it creates.
	void sendquery(string s);

};

