import std.stdio;
import std.string;
import std.conv;
import std.typecons;

import std.container : SList;
import std.container : DList;

import std.variant;

alias Token = Algebraic!(int, string);

SList!Token            stack;
DList!Token[string]    words;
int[string]            variables;
Nullable!(DList!Token) definition;

void startDefinition()
in  { assert( definition.isNull); }
out { assert(!definition.isNull); }
body {
	definition = DList!Token();
}

void endDefinition()
in  { assert(!definition.isNull); }
out { assert( definition.isNull); }
body {
	string wordToBeDefined;

	definition.front.visit!(
		(int    x   ) => wordToBeDefined = "",
		(string name) => wordToBeDefined = name
	);

	if ( wordToBeDefined == "" ) {
		throw new Exception("words may not be numeric");
	}

	definition.removeFront;
	words[wordToBeDefined] = definition;
	definition.nullify;
}

void append(ref Nullable!(DList!Token) definition, int value) {
	definition.insertBack(Token(value));
}

void append(ref Nullable!(DList!Token) definition, string word) {
	if ( word == ";" ) {
		endDefinition();
	} else {
		definition.insertBack(Token(word));
	}
}

void evaluate(string word) {
	switch ( word ) {
		case "§":
			startDefinition();
			break;
		case "$":
			string name  = stack.pop().get!string;
			int    value = stack.pop().get!int;

			variables[name] = value;
			break;
		case "@":
			string name = stack.pop().get!string;

			if ( name in variables ) {
				stack.push(variables[name]);
			}
			break;
		case "+":
			int a = stack.pop().get!int;
			int b = stack.pop().get!int;

			stack.push(a + b);
			break;
		case "*":
			int a = stack.pop().get!int;
			int b = stack.pop().get!int;

			stack.push(a * b);
			break;
		case ".":
			writeln(stack.front);
			break;
		default:
			if ( word in words ) {
				foreach ( token; words[word] ) {
					process(token);
				}
			} else {
				stack.push(word);
			}
	}
}

void process(Token token) {
	token.visit!(
		(int    x   ) => process(x),
		(string word) => process(word)
	);
}

void process(int x) {
	stack.push(x);
}

void process(string word) {
	evaluate(word);
}

void push(ref SList!Token stack, int value) {
	if ( definition.isNull ) {
		stack.insertFront(Token(value));
	} else {
		definition.append(value);
	}
}

void push(ref SList!Token stack, string word) {
	if ( definition.isNull ) {
		stack.insertFront(Token(word));
	} else {
		definition.append(word);
	}
}

Token pop(ref SList!Token stack) {
	Token token = stack.front;
	stack.removeFront;
	return token;
}

void main() {
	while ( !stdin.eof ) {
		foreach ( token; stdin.readln.split ) {
			if ( definition.isNull ) {
				if ( token.isNumeric ) {
					process(parse!int(token));
				} else {
					process(token);
				}
			} else {
				if ( token.isNumeric ) {
					definition.append(parse!int(token));
				} else {
					definition.append(token);
				}
			}
		}
	}
}
