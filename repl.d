import std.stdio;
import std.string;
import std.conv;
import std.typecons;

import std.container : SList;
import std.container : DList;

SList!int               stack;
DList!string[string]    words;
Nullable!(DList!string) definition;

void startDefinition()
in  { assert( definition.isNull); }
out { assert(!definition.isNull); }
body {
	definition = DList!string();
}

void endDefinition()
in  { assert(!definition.isNull); }
out { assert( definition.isNull); }
body {
	auto wordToBeDefined = definition.front;

	if ( wordToBeDefined.isNumeric ) {
		throw new Exception("words may not be numeric");
	} else {
		definition.removeFront;
		words[wordToBeDefined] = definition;
		definition.nullify;
	}
}

void append(ref Nullable!(DList!string) definition, string token) {
	if ( token == ";" ) {
		endDefinition();
	} else {
		definition.insertBack(token);
	}
}

void evaluate(string word) {
	switch ( word ) {
		case "§":
			startDefinition();
			break;
		case "+":
			auto a = stack.pop();
			auto b = stack.pop();

			stack.push(a + b);
			break;
		case "*":
			auto a = stack.pop();
			auto b = stack.pop();

			stack.push(a * b);
			break;
		case ".":
			writeln(stack.front);
			break;
		default:
			foreach ( token; words[word] ) {
				process(token);
			}
	}
}

void process(string token) {
	if ( token.isNumeric ) {
		stack.push(parse!int(token));
	} else {
		evaluate(token);
	}
}

void push(ref SList!int stack, int value) {
	if ( definition.isNull ) {
		stack.insertFront(value);
	} else {
		definition.append(to!string(value));
	}
}

int pop(ref SList!int stack) {
	auto x = stack.front;
	stack.removeFront;

	return x;
}

void main() {
	while ( !stdin.eof ) {
		foreach ( token; stdin.readln.split ) {
			if ( definition.isNull ) {
				process(token);
			} else {
				definition.append(token);
			}
		}
	}
}
