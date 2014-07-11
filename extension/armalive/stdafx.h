// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once
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

#define _CRT_SECURE_NO_WARNINGS
#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
#include <Windows.h>
#include <libpq-fe.h>


extern std::ofstream logfile;

