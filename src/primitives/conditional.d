module src.primitives.conditional;

import std.variant;
import std.typecons;
import std.container : DList;

import src.stack;

Nullable!(DList!Token) buffer;
bool                   concluded = true;
bool                   drop_mode = false;

void capture(Token token) {
	if ( !drop_mode ) {
		buffer.insertBack(token);
	}
}

bool drop(Token token) {
	if ( concluded && buffer.isNull ) {
		return false;
	}

	if ( token.type == typeid(string) ) {
		switch ( *token.peek!string ) {
			case "if"   : eval_if;        break;
			case "then" : eval_then;      break;
			case "else" : eval_else;      break;
			default     : capture(token); break; 
		}
	} else {
		capture(token);
	}

	return true;
}

void eval_if() {
	if ( concluded ) {
		buffer    = DList!Token();
		drop_mode = !stack.pop.get!bool;
		concluded = false;
	} else {
		throw new Exception("conditionals may not be nested directly");
	}
}

void eval_then() {
	if ( concluded  ) {
		throw new Exception("`then` without preceding `if`");
	} else {
		drop_mode = !drop_mode;
	}
}

void eval_else() {
	if ( concluded ) {
		throw new Exception("`else` without preceding `if`");	
	} else {
		drop_mode = false;
		concluded = true;
	}
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
