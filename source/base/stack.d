module base.stack;

import std.conv;
import std.string;
import std.variant;
import std.container : SList;

alias Token = Algebraic!(int, bool, string);
alias Stack = SList;

Stack!Token stack;

Token toToken(string value) {
	if ( value.isNumeric ) {
		return Token(parse!int(value));
	} else {
		return Token(value);
	}
}

Token top(ref Stack!Token stack) {
	if ( stack.empty ) {
		throw new Exception("stack is empty");
	} else {
		return stack.front;
	}
}

Token pop(ref Stack!Token stack) {
	Token token = stack.top;
	stack.removeFront;
	return token;
}

template push(T)
if ( is(T == int) || is(T == bool) || is (T == string) ) {
	void push(ref Stack!Token stack, T value) {
		stack.push(Token(value));
	}
}

void push(ref Stack!Token stack, Token token) {
	stack.insertFront(token);
}

void push(ref Stack!Token stack, Stack!Token prefix) {
	stack.insertFront(prefix[]);
}
