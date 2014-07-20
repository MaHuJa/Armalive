#pragma once

template <class T>
class squeue {
	std::deque<T> content;
	std::mutex qm;
	typedef std::lock_guard<std::mutex> guard;
public:

	void push(T t) {
		guard g(qm);
		content.push_back(move(t));
	}

	// .second is true if there is an actual result
	std::pair<T,bool> pop() {
		std::pair<T, bool> ret;
		guard g(qm);
		if (content.empty()) {
			ret.second = false;
		}
		else {
			ret.first = move(content.front());
			content.pop_front();
			ret.second = true;
		}
		return ret;
	}
};



