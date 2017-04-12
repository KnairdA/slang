module src.stack;

import std.variant;
import std.string;
import std.container : SList;

static import src.definition;

alias Token = Algebraic!(int, bool, string);
alias Stack = SList;

Stack!Token stack;

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

void push(ref Stack!Token stack, Token token) {
	if ( !src.definition.handle(token) ) {
		stack.insertFront(token);
	}
}

template push(T)
if ( is(T == int) || is(T == bool) || is (T == string) ) {
	void push(ref Stack!Token stack, T value) {
		stack.push(Token(value));
	}
}
