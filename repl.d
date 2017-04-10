import std.stdio;
import std.string;
import std.conv;
import std.container : SList;
import std.container : DList;
import std.variant;

alias Token = Algebraic!(int, string);

auto dataStack = SList!int();

bool   defMode     = false;
string defModeWord = "";

DList!Token[string] wordMap;

void push(ref DList!Token stack, int value) {
	stack.insertBack(Token(value));
}

void push(ref DList!Token stack, string word) {
	stack.insertBack(Token(word));
}

void push(ref DList!Token[string] map, int value) {
	map[defModeWord].push(value);
}

void push(ref DList!Token[string] map, string word) {
	if ( defModeWord == "" ) {
		defModeWord      = word;
		map[defModeWord] = DList!Token();
	} else {
		map[defModeWord].push(word);
	}
}

void push(ref SList!int stack, int value) {
	if ( defMode ) {
		wordMap.push(value);
	} else {
		stack.insertFront(value);
	}
}

void push(ref SList!int stack, string word) {
	if ( defMode ) {
		if ( word == ";" ) {
			defMode     = false;
			defModeWord = "";
		} else {
			wordMap.push(word);
		}
	} else {
		switch ( word ) {
			case "§":
				defMode     = true;
				defModeWord = "";
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
				foreach ( token; wordMap[word] ) {
					if ( token.type == typeid(int) ) {
						stack.push(*token.peek!int);
					} else {
						stack.push(*token.peek!string);
					}
				}
		}
	}
}

int pop(ref SList!int stack) {
	auto x = stack.front;
	stack.removeFront;

	return x;
}

void main() {
	while ( !stdin.eof ) {
		foreach ( word; stdin.readln.split ) {
			if ( word.isNumeric ) {
				dataStack.push(parse!int(word));
			} else {
				dataStack.push(word);
			}
		}
	}
}
