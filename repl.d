import std.stdio;
import std.string;
import std.conv;
import std.variant;
import std.typecons;

import std.container : SList;

import src.stack;

static import definition = src.definition;
static import primitives = src.primitives.eval;

void process(int x) {
	try {
		if ( !primitives.evaluate(x) ) {
			stack.push(x);
		}
	}
	catch (Exception ex) {
		writeln("Error: ", ex.msg);
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
		(int    x   ) => process(x),
		(string word) => process(word)
	);
}

void main() {
	while ( !stdin.eof ) {
		foreach ( token; stdin.readln.split ) {
			if ( token.isNumeric ) {
				immutable int value = parse!int(token);

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
