import std.stdio;
import std.string;
import std.conv;
import std.variant;
import std.typecons;

import std.container : SList;

import src.stack;

static import definition = src.definition;
static import primitives = src.primitives.eval;

template process(T)
if ( is(T == int) || is(T == bool) ) {
	void process(T value) {
		try {
			if ( !primitives.evaluate(value) ) {
				stack.push(value);
			}
		}
		catch (Exception ex) {
			writeln("Error: ", ex.msg);
		}
	}
}

void process(string word) {
	try {
		if ( !primitives.evaluate(word) ) {
			if ( word in definition.words ) {
				foreach ( token; definition.words[word] ) {
					process(token);
				}
			} else {
				stack.push(word);
			}
		}
	}
	catch (Exception ex) {
		writeln("Error: ", ex.msg);
	}
}

void process(Token token) {
	token.visit!(
		(int    value) => process(value),
		(bool   value) => process(value),
		(string word ) => process(word)
	);
}

void main() {
	while ( !stdin.eof ) {
		foreach ( token; stdin.readln.split ) {
			if ( token.isNumeric ) {
				auto value = parse!int(token);

				if ( !definition.handle(value) ) {
					process(value);
				}
			} else {
				if ( !definition.handle(token) ) {
					process(token);
				}
			}
		}
	}
}
