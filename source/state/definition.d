module state.definition;

import std.string;
import std.variant;
import std.typecons;

import std.container : DList;

import state.stack;

alias Words = Stack!Token[string];

Words words;

bool handle(Token token) {
	return token.visit!(
		(int    value) => handle(value),
		(bool   value) => handle(value),
		(string word ) => handle(word),
		(DList!int  v) => handle(v)
	);
}

Stack!Token get(string word) {
	if ( word in words ) {
		return words[word].dup;
	} else {
		return Stack!Token(Token(word));
	}
}

private {

Nullable!(DList!Token) definition;

void register(DList!Token definition) {
	string wordToBeDefined;

	definition.front.visit!(
		(int    value) => wordToBeDefined = "",
		(bool   value) => wordToBeDefined = "",
		(string name ) => wordToBeDefined = name,
		(DList!int  v) => wordToBeDefined = ""
	);

	if ( wordToBeDefined == "" ) {
		throw new Exception("words may not be numeric or boolean");
	}

	definition.removeFront;
	words[wordToBeDefined] = Stack!Token(definition[]);
}

template handle(T)
if ( is(T == int) || is(T == bool) || is(T == DList!int) ) {
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
		switch ( word ) {
			case "§" :
				throw new Exception("definitions may not be nested");
			case ";" :
				register(definition);
				definition.nullify;
				break;
			default:
				definition.insertBack(Token(word));
		}

		return true;
	}
}

}
