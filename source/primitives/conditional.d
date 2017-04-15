module primitives.conditional;

import std.variant;
import std.typecons;
import std.container : DList;

import base.stack;

Nullable!(DList!Token) buffer;
bool                   concluded = true;
bool                   drop_mode = false;

void unary_op_if() {
	if ( concluded ) {
		buffer    = DList!Token();
		drop_mode = !stack.pop.get!bool;
		concluded = false;
	} else {
		throw new Exception("conditionals may not be nested directly");
	}
}

void n_ary_op_then() {
	if ( concluded  ) {
		throw new Exception("`then` without preceding `if`");
	} else {
		drop_mode = !drop_mode;
	}
}

void n_ary_op_else() {
	if ( concluded ) {
		throw new Exception("`else` without preceding `if`");
	} else {
		drop_mode = false;
		concluded = true;
	}
}

bool capture(Token token) {
	if ( concluded && buffer.isNull ) {
		return false;
	} else {
		if ( !drop_mode ) {
			buffer.insertBack(token);
		}

		return true;
	}
}

bool handle(string word) {
	switch ( word ) {
		case "if"   : unary_op_if;   return true;
		case "then" : n_ary_op_then; return true;
		case "else" : n_ary_op_else; return true;
		default     :                return capture(Token(word));
	}
}

bool handle(Token token) {
	return token.visit!(
		(int        ) => capture(token),
		(bool       ) => capture(token),
		(string word) => handle(word)
	);
}

bool dischargeable() {
	return concluded && !buffer.isNull;
}

Stack!Token discharge() {
	if ( concluded ) {
		Stack!Token result = buffer[];
		buffer.nullify;
		return result;
	} else {
		throw new Exception("unconcluded conditional may not be discharged");
	}
}
