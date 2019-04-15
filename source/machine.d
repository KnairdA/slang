module machine;

import std.string;
import std.variant;

import std.stdio          : writeln;
import std.container.util : make;

import state.stack;

import definition  = state.definition;
import variable    = state.variable;

import core        = primitives.core;
import conditional = primitives.conditional;

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
		if ( definition.handle(token) ) {
			return Stack!Token();
		}

		if ( conditional.handle(token) ) {
			if ( conditional.dischargeable ) {
				return conditional.discharge;
			} else {
				return Stack!Token();
			}
		}

		if ( variable.handle(token) ) {
			return Stack!Token();
		}

		if ( core.handle(token) ) {
			return Stack!Token();
		}

		return token.visit!(
			(int        ) => Stack!Token(token),
			(bool       ) => Stack!Token(token),
			(string word) => definition.get(word),
			(DList!int  ) => Stack!Token(token)
		);
	}
	catch (Exception ex) {
		writeln("Error: ", ex.msg);
		return Stack!Token();
	}
}

}
