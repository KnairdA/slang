module primitives.eval;

import std.variant;

import state.stack;

import definition  = state.definition;
import variable    = state.variable;

import core        = primitives.core;
import conditional = primitives.conditional;

bool evaluate(Token token) {
	if ( definition.handle(token) ) {
		return true;
	}

	if ( conditional.handle(token) ) {
		return true;
	}

	if ( variable.handle(token) ) {
		return true;
	}

	return token.visit!(
		(int    value) => false,
		(bool   value) => false,
		(string word ) => core.handle(word)
	);
}

Stack!Token result() {
	if ( conditional.dischargeable ) {
		return conditional.discharge;
	} else {
		return Stack!Token();
	}
}
