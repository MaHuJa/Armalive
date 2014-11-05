#include "stdafx.h"
#include "dbthread.h"

void dbthread::connectloop() {	
	while (!conn.is_connected()) {
		logfile << "Connect error: " << conn.error_message();
		std::this_thread::sleep_for(std::chrono::seconds(conn.retries));
		conn.reconnect();
	}
}
std::string dbthread::make_query(string input) {
	paramlist p = split(input);
	assert(!p.empty());
	p[0] = conn.escapename(p[0]);
	for (auto it = begin(p) + 1; it != end(p); it++)
		*it = conn.escapestring(*it);
	std::ostringstream cmd;
	cmd << "SELECT \"server\"." << std::move(p[0]) << '(' << sessionid;
	for (auto it = p.begin() + 1; it < p.end(); it++) {
		cmd << ',' << std::move(*it);
	}
	cmd << ");";
	return cmd.str();
}
std::string dbthread::task_newmission(string input) {
	string query = make_query(input);
	auto res = conn.exec(query);
	if (res.failed()) { send_error(conn.error_message(), input); }
	string s;
	if (res.has_data()) {
		s = res.get_single_value();
		std::istringstream is(s); is >> sessionid;	// aka lexical_cast
		logfile << "New session ID " << sessionid << '\n';
		logfile.flush();
	}
	else {
		send_error("No returned session id!", input);
		sessionid = 0;	// Which will cause subsequent calls to fail as well
	}
	return s;
}
std::string dbthread::task_send(string input) {
	string query = make_query(input);
	auto res = conn.exec(query);
	if (res.failed()) { send_error(conn.error_message(), input); }
	return "";
}
std::string dbthread::task_ask(string input) {
	string query = make_query(input);
	auto res = conn.exec(query);
	if (res.failed()) { send_error(conn.error_message(), input); }

	if (res.has_data()) {
		input = res.get_single_value();
	}
	return input;
}

void dbthread::run() {
	std::string s;
	{
		std::ifstream infile ("armalive_conninfo");
		if (!infile.is_open()) infile.open("@armalive/armalive_conninfo");
		if (!infile.is_open()) infile.open("../armalive_conninfo");
		if (!infile.is_open()) {
			logfile << "Can't connect to db: File armalive_conninfo does not exist!\n"; 
			logfile.flush();
			return; 
		}
		std::getline (infile,s); 
	}

	conn.connect(s);
	connectloop();

	while (running) {
		Task t = grab_cmd();
		if (!t.valid())
			continue;	// Running is false, or caller sent blank string
		t();
	}
}

dbthread::~dbthread() {
	running = false;
	if (my_thread.joinable()) my_thread.join();
}

dbthread::Task dbthread::grab_cmd () {
	bool is_empty = false;
	do {
		if (!running) return Task();
		auto main = mainqueue.pop();
		if (!main.second) {
			std::this_thread::sleep_for(std::chrono::milliseconds(200));
			continue;
		}
		return move(main.first);
	} while (true);
}
dbthread::paramlist dbthread::split(string in) {
	const char separator = ';';
	paramlist out;
	auto iter = in.begin();
	while (iter != in.end()) {
		auto wordbegin = iter;
		iter = std::find(iter,in.end(),separator);
		out.emplace_back(wordbegin,iter);
		if (iter!=in.end()) iter++;	// it's at a ; and will generate endless empty strings otherwise.
	}
	return out;
}
void dbthread::send_error(string msg, string input) {
	logfile << "Error: " << input << '\n' << msg << '\n';
	logfile.flush();
	// for the time being, we'll also do
	std::cerr << "Error: " << msg << '\n' << input << '\n';
	// and sometime in the future also push the error to the database.
}

