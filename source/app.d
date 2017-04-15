import std.stdio;
import std.string;
import std.variant;

import std.container.util : make;

import base.stack;

import definition = base.definition;
import primitives = primitives.eval;

Stack!Token resolve(Token token) {
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

void process(string value) {
	auto buffer = make!(Stack!Token)(toToken(value));

	do {
		Token current = buffer.pop;

		if ( !definition.handle(current) ) {
			Stack!Token resolved = resolve(current);

			if ( !resolved.empty ) {
				if ( resolved.front == current ) {
					stack.push(current);
				} else {
					buffer.insertFront(resolved[]);
				}
			}
		}
	}
	while ( !buffer.empty );
}

void main() {
	while ( !stdin.eof ) {
		foreach ( token; stdin.readln.split ) {
			process(token);
		}
	}
}