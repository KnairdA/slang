module machine;

import std.string;
import std.variant;

import std.stdio          : writeln;
import std.container.util : make;

import definition = base.definition;
import primitives = primitives.eval;

import base.stack;

void process(string value) {
	auto buffer = make!(Stack!Token)(toToken(value));

	do {
		Token       current = buffer.pop;
		Stack!Token result  = evaluate(current);

		if ( !result.empty ) {
			if ( result.front == current ) {
				stack.push(current);
			} else {
				buffer.push(result);
			}
		}
	}
	while ( !buffer.empty );
}

private {

Stack!Token evaluate(Token token) {
	try {
		if ( primitives.evaluate(token) ) {
			return primitives.result;
		} else {
			return token.visit!(
				(int    value) => Stack!Token(Token(value)),
				(bool   value) => Stack!Token(Token(value)),
				(string word ) => definition.get(word)
			);
		}
	}
	catch (Exception ex) {
		writeln("Error: ", ex.msg);
		return Stack!Token();
	}
}

}
