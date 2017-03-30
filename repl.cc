#include <iostream>

#include <stack>
#include <string>
#include <algorithm>

#include <cctype>
#include <cstdlib>

bool is_number(const std::string& token) {
	return std::all_of(
		token.begin(),
		token.end(),
		[](char c) { return std::isdigit(c); }
	);
}

bool is_primitive(const std::string& token) {
	return token == "+"
	    || token == "-"
	    || token == "*"
	    || token == "."
	    || token == "swp"
	    || token == "dup"
	    || token == "del";
}

void process(std::stack<int>& stack, const std::string& token) {
	if ( token == "+" ) {
		const int b = stack.top();
		stack.pop();
		const int a = stack.top();
		stack.pop();

		stack.push(a + b);
	} else if ( token == "-" ) {
		const int b = stack.top();
		stack.pop();
		const int a = stack.top();
		stack.pop();

		stack.push(a - b);
	} else if ( token == "*" ) {
		const int b = stack.top();
		stack.pop();
		const int a = stack.top();
		stack.pop();

		stack.push(a * b);
	} else if ( token == "." ) {
		std::cout << stack.top() << std::endl;
	} else if ( token == "swp" ) {
		const int b = stack.top();
		stack.pop();
		const int a = stack.top();
		stack.pop();

		stack.push(b);
		stack.push(a);
	} else if ( token == "dup" ) {
		stack.push(stack.top());
	} else if ( token == "del" ) {
		stack.pop();
	}
}

int main(int, char*[]) {
	std::stack<int> stack;
	std::string     token;

	while ( std::cin.good() ) {
		if ( std::cin >> token ) {
			if ( is_number(token) ) {
				stack.push(std::atoi(token.c_str()));
			} else if ( is_primitive(token) ) {
				process(stack, token);
			}
		}
	}

	return 0;
}
