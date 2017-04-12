module src.stack;

import std.variant;
import std.string;
import std.container : SList;

static import src.definition;

alias Token = Algebraic!(int, string);
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

void push(ref Stack!Token stack, int value) {
	if ( !src.definition.handle(value) ) {
		stack.insertFront(Token(value));
	}
}

void push(ref Stack!Token stack, string word) {
	if ( !src.definition.handle(word) ) {
		stack.insertFront(Token(word));
	}
}
