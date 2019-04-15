module state.variable;

import std.variant;

import state.stack;

bool handle(string word) {
	switch ( word ) {
		case "$" : binary_op_variable_bind;   return true;
		case "@" : unary_op_variable_resolve; return true;
		default  :                            return false;
	}
}

bool handle(Token token) {
	return token.visit!(
		(int        ) => false,
		(bool       ) => false,
		(string word) => handle(word),
		(DList!int  ) => false
	);
}

private {

Token[string] variables;

void binary_op_variable_bind() {
	string name     = stack.pop.get!string;
	Token  value    = stack.pop;
	variables[name] = value;
}

void unary_op_variable_resolve() {
	string name = stack.pop.get!string;

	if ( name in variables ) {
		stack.push(variables[name]);
	}
}

}
