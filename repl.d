import std.stdio;
import std.string;
import std.conv;
import std.variant;
import std.typecons;

import std.container : SList;

import src.stack;

static import src.definition;
static import src.primitives;

void process(int x) {
	stack.push(x);
}

void process(string word) {
	try {
		if ( !src.primitives.evaluate(word) ) {
			if ( word in src.definition.words ) {
				foreach ( token; src.definition.words[word] ) {
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

				if ( !src.definition.handle(value) ) {
					process(value);
				}
			} else {
				if ( !src.definition.handle(token) ) {
					process(token);
				}
			}
		}
	}
}
