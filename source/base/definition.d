module base.definition;

import std.string;
import std.variant;
import std.typecons;

import std.container : DList;

import base.stack;

alias Words = Stack!Token[string];

Nullable!(DList!Token) definition;
Words                  words;

void start() {
	definition = DList!Token();
}

void end() {
	string wordToBeDefined;

	definition.front.visit!(
		(int    value) => wordToBeDefined = "",
		(bool   value) => wordToBeDefined = "",
		(string name ) => wordToBeDefined = name
	);

	if ( wordToBeDefined == "" ) {
		throw new Exception("words may not be numeric or boolean");
	}

	definition.removeFront;
	words[wordToBeDefined] = Stack!Token(definition[]);
	definition.nullify;
}

bool handle(Token token) {
	if ( definition.isNull ) {
		return false;
	} else {
		if ( token.type == typeid(string) ) {
			if ( *token.peek!string == ";" ) {
				end;
			} else {
				definition.insertBack(token);
			}
		} else {
			definition.insertBack(token);
		}

		return true;
	}
}

Stack!Token get(string word) {
	if ( word in words ) {
		return words[word].dup;
	} else {
		return Stack!Token(Token(word));
	}
}
