#include "stdafx.h"
#include "dbthread.h"

void dbthread::connectloop() {	
	while (!conn.is_connected()) {
		logfile << "Connect error: " << conn.error_message();
		std::this_thread::sleep_for(std::chrono::seconds(conn.retries));
		if (!running) break;
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
		// reusing existing string object
		s = res.get_single_value();
		std::istringstream is(s); is >> sessionid;	// aka lexical_cast
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
		if (!infile.is_open()) { 
			logfile << "Can't connect to db: File armalive_conninfo does not exist!\n"; 
			return; 
		}
		std::getline (infile,s); 
	}

	conn.connect(s);
	connectloop();

	while (true) {
		Task t = grab_cmd();
		if (!t.valid()) {
			if (!running) return;
			std::this_thread::sleep_for(std::chrono::milliseconds(200));
			continue;
		}
		t();
	}
}

dbthread::~dbthread() {
	running = false;
	if (my_thread.joinable()) my_thread.join();
}

dbthread::Task dbthread::grab_cmd () {
	Task t = 
		// fasttrack.pop()
		// if (!t.valid()) t = 
		mainqueue.pop();
	return t;	
}
dbthread::paramlist dbthread::split(string in) {
	// I considered regexes, but then I'd have two problems... 
	// I mean, it would be quite complicated to handle escaping etc
	// But then I decided not to do that sort of stuff.

	// It was the intention to treat "custom data" that could contain a ; as a last field, 
	// but that requires that I can detect and pass the correct number of parameters.
	// Ah well, I'll have to piece them together later somehow.
	// At worst it will fail that command, or it will truncate that name.
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
	logfile << "Error: " << input << '\n' << msg << std::endl;
	// for the time being, we'll also do
	std::cerr << "Error: " << msg << '\n' << input << '\n';
	// and sometime in the future also push the error to the database.
}

