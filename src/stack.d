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

void push(ref Stack!Token stack, Token token) {
	if ( !token.visit!(
		(int    x   ) => src.definition.handle(x),
		(string word) => src.definition.handle(word)
	) ) {
		stack.insertFront(token);
	}
}

void push(ref Stack!Token stack, int value) {
	stack.push(Token(value));
}

void push(ref Stack!Token stack, string word) {
	stack.push(Token(word));
}
