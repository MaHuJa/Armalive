#include "stdafx.h"
#include "dbthread.h"

void dbthread::connectloop() {	
	while (!conn.is_connected()) {
		logfile << "Connect error: " << conn.error_message();
		std::this_thread::sleep_for(std::chrono::seconds(conn.retries));
		conn.reconnect();
	}
}
void dbthread::run() {
	std::string s;
	{
		std::ifstream infile ("armalive_conninfo");
		if (!infile.is_open()) { 
			logfile << "Can't connect to db: File conninfo does not exist!\n"; 
			return; 
		}
		std::getline (infile,s); 
	}

	conn.connect(s);
	connectloop();

	while (running) {
		string s = grab_cmd();
		if (s.empty()) continue;	// Running is false, or caller sent blank string
		paramlist p = split(s);
		assert (!p.empty());
		p[0] = conn.escapename(p[0]);
		for (auto it = begin(p)+1; it!=end(p); it++) 
			*it = conn.escapestring(*it);

		std::ostringstream cmd;
		// newsession is a special case because we need to react to its return value
		if (p[0]=="\"newmission1\"") { // TODO support any newer version
			if (p.size()<2) {
				send_error("Newsession missing parameter",s);
				throw std::invalid_argument("Missing parameter");
			}
			cmd << "SELECT \"server\"." << std::move(p[0]) << '(' 
				<< sessionid << ',' // previous session id
				<< std::move(p[1]) << ");";
			string command = cmd.str();	//For debug purposes
			auto r = conn.exec(command);
			if (r.failed()) { 
				send_error(conn.error_message(),command); 
			}

			s = r.get_single_value();
			std::istringstream is(s); is >> sessionid;	// aka lexical_cast
		} else {
			// Normal case
			cmd << "SELECT \"server\"." << std::move(p[0]) << '(' << sessionid;
			for (auto it = p.begin()+1; it<p.end(); it++) {
				cmd << ',' << std::move(*it);
			}
			cmd << ");";
			auto r = conn.exec(cmd.str());
			if (r.failed()) { send_error(conn.error_message(),s); }
		}
	}
}

void dbthread::sendquery (std::string s) {
	guard g(qm);
	q.push_back(std::move(s));
};
dbthread::~dbthread() {
	running = false;
	if (my_thread.joinable()) my_thread.join();
}

std::string dbthread::grab_cmd () {
	string s;
	bool is_empty = false;
	do {
		if (!running) return s;
		if (is_empty) { // was empty last try, putting us here right away
			std::this_thread::sleep_for(std::chrono::milliseconds(500));
		}
		guard g(qm);
		if (q.empty()) { 
			is_empty = true;
		} else {
			is_empty = false;
			s = q.front();
			q.pop_front();
		}
	} while (is_empty);
	return s;
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
	logfile << "Error: " << msg << '\n' << input << '\n';
	// for the time being, we'll also do
	std::cerr << "Error: " << msg << '\n' << input << '\n';
	// and sometime in the future also push the error to the database.
}

