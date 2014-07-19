#pragma once
#include "pg.h"
#include "squeue.h"

class dbthread { 
	typedef std::string string;
	pg::Connection conn;
	std::thread my_thread;
	squeue<string> mainqueue;

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
	void sendquery(string s) {
		mainqueue.push(s);
	}

};

