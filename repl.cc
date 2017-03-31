#include <iostream>

#include <stack>
#include <string>
#include <algorithm>

#include <unordered_map>
#include <functional>

#include <cctype>
#include <cstdlib>

bool is_number(const std::string& token) {
	return std::all_of(
		token.begin(),
		token.end(),
		[](char c) { return std::isdigit(c); }
	);
}

int main(int, char*[]) {
	std::stack<int> stack;
	std::string     token;

	std::unordered_map<std::string, std::function<void(void)>> builtin{
		{
			"+", [&stack]() {
				const int b = stack.top();
				stack.pop();
				const int a = stack.top();
				stack.pop();

				stack.push(a + b);
			}
		},
		{
			"-", [&stack]() {
				const int b = stack.top();
				stack.pop();
				const int a = stack.top();
				stack.pop();

				stack.push(a - b);
			}
		},
		{
			"*", [&stack]() {
				const int b = stack.top();
				stack.pop();
				const int a = stack.top();
				stack.pop();

				stack.push(a * b);
			}
		},
		{
			".", [&stack]() {
				std::cout << stack.top() << std::endl;
			}
		},
		{
			"swp", [&stack]() {
				const int b = stack.top();
				stack.pop();
				const int a = stack.top();
				stack.pop();

				stack.push(b);
				stack.push(a);
			}
		},
		{
			"dup", [&stack]() {
				stack.push(stack.top());
			}
		},
		{
			"del", [&stack]() {
				stack.pop();
			}
		}
	};

	while ( std::cin.good() ) {
		if ( std::cin >> token ) {
			if ( is_number(token) ) {
				stack.push(std::atoi(token.c_str()));
			} else {
				const auto& impl = builtin.find(token);

				if ( impl != builtin.end() ) {
					impl->second();
				}
			}
		}
	}

	return 0;
}
