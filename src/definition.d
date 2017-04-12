module src.definition;

import std.string;
import std.variant;
import std.typecons;
import std.container : DList;

import src.stack : Token;

alias Words = DList!Token[string];

Nullable!(DList!Token) definition;
Words                  words;

void start() {
	definition = DList!Token();
}

void end() {
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

bool handle(int value) {
	if ( definition.isNull ) {
		return false;
	} else {
		definition.insertBack(Token(value));
		return true;
	}
}

bool handle(string word) {
	if ( definition.isNull ) {
		return false;
	} else {
		if ( word == ";" ) {
			end();
		} else {
			definition.insertBack(Token(word));
		}

		return true;
	}
}
