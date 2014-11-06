// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#ifdef __LINUX__
#pragma GCC visibility push(hidden)
#endif

#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <fstream>
#include <cassert>
#include <thread>
#include <mutex>
#include <chrono>
#include <vector>
#include <deque>
#include <map>
#include <stdexcept>
#include <algorithm>
#include <future>
#include <cstring>
#include <cstdlib>

#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
#include <Windows.h>
#endif

#include <libpq-fe.h>

extern std::ofstream logfile;


