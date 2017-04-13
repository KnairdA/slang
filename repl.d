import std.stdio;
import std.string;
import std.variant;
import std.typecons;

import src.stack;

static import definition = src.definition;
static import primitives = src.primitives.eval;

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
	Stack!Token buffer;
	Token token = toToken(value);

	if ( !definition.handle(token) ) {
		buffer = resolve(token);
	}

	while ( !buffer.empty ) {
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
}

void main() {
	while ( !stdin.eof ) {
		foreach ( token; stdin.readln.split ) {
			process(token);
		}
	}
}
