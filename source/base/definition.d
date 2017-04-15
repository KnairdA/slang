module base.definition;

import std.string;
import std.variant;
import std.typecons;

import std.container : DList;

import base.stack;

alias Words = Stack!Token[string];

Nullable!(DList!Token) definition;
Words                  words;

void register(DList!Token definition) {
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
}

template handle(T)
if ( is(T == int) || is(T == bool) ) {
	bool handle(T value) {
		if ( definition.isNull ) {
			return false;
		} else {
			definition.insertBack(Token(value));
			return true;
		}
	}
}

bool handle(string word) {
	if ( definition.isNull ) {
		if ( word == "§" ) {
			definition = DList!Token();
			return true;
		} else {
			return false;
		}
	} else {
		if ( word == ";" ) {
			register(definition);
			definition.nullify;
		} else {
			definition.insertBack(Token(word));
		}

		return true;
	}
}

bool handle(Token token) {
	return token.visit!(
		(int    value) => handle(value),
		(bool   value) => handle(value),
		(string word ) => handle(word)
	);
}

Stack!Token get(string word) {
	if ( word in words ) {
		return words[word].dup;
	} else {
		return Stack!Token(Token(word));
	}
}
