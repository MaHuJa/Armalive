#include "stdafx.h"
#include "pg.h"

#include <libpq-fe.h>

namespace pg {
namespace { 
	PGconn* connection(void* p) { return static_cast<PGconn*>(p); }
	PGresult* result(void* p) { return static_cast<PGresult*>(p); }
}

void Connection::connect(std::string conninfo) {
	conn = PQconnectdb(conninfo.c_str());
}
void Connection::disconnect() {
	PQfinish(connection(conn));
}
std::string Connection::error_message() const {
	return PQerrorMessage(connection(conn));
}
bool Connection::is_connected() {
	bool status = PQstatus(connection(conn)) == CONNECTION_OK;
	if (status) retries = 0;
	return status;
}
bool Connection::reconnect() {
	retries++;
	PQreset(connection(conn));
	return is_connected();
}
Result Connection::exec(std::string query) {
	return PQexec(connection(conn),query.c_str());
}
Result::Result(void* p) :res(p) {}
Result::~Result() {
	// I don't seem to need to clear the result of tuples; clear takes care of that.
	PQclear(result(res));
}

std::string Result::get_single_value() {
	PGresult* p = result(res);
	if (PQntuples(p) != 1 || PQnfields(p) != 1 || PQfformat(p, 0) != 0)	// format is text
	{
		__asm nop;	// breakpoint me!
		// TODO: Exception
	}
	return PQgetvalue(p, 0, 0);
}

std::string Connection::escapestring(std::string in)  const {
	char* s = PQescapeLiteral(connection(conn),in.c_str(),in.size());
	
	if (!s) {
		std::ostringstream out;
		out << "Error on db escapestring: " << error_message();
		throw std::runtime_error(out.str());
	}
	std::string out(s);	// TODO memory leaks if this throws
	PQfreemem(s);
	return out;
}
std::string Connection::escapename(std::string in)  const {
	char* s = PQescapeIdentifier(connection(conn),in.c_str(),in.size());
	
	if (!s) {
		std::ostringstream out;
		out << "Error on db escapestring: " << error_message();
		throw std::runtime_error(out.str());
	}
	std::string out(s);	// TODO memory leaks if this throws
	PQfreemem(s);
	return out;
}

bool Result::failed() {
	auto status = PQresultStatus(result(res));
	switch(status) {
	case PGRES_COMMAND_OK:
	case PGRES_TUPLES_OK:
		return false;
	default:
		return true;
	}
}

}// namespace
