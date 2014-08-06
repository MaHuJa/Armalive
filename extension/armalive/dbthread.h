#pragma once
#include "pg.h"
#include "squeue.h"

class dbthread {
public:
	using string = std::string;
	using Task = std::packaged_task <string()>;
	using paramlist = std::vector<string>;
private:
	pg::Connection conn;
	std::thread my_thread;

	long int sessionid;
	bool running;
	void run();
	void connectloop();


	paramlist split(string);
	Task grab_cmd();
	void send_error(string msg, string input);
	string make_query(paramlist);
public:
	dbthread() : my_thread(&dbthread::run,this), running(true), sessionid(0) {}
	dbthread(dbthread&) = delete;
	~dbthread();
	bool is_online();

	string task_send(string input);
	string task_ask(string input);

	squeue<Task> mainqueue;
	// Not yet: squeue<Task> fasttrack;

};

