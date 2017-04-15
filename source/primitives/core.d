module primitives.core;

import std.stdio;

import base.stack;

Token[string] variables;

bool handle(string word) {
	switch ( word ) {
		case     "$"     : binary_op_variable_bind;      break;
		case     "@"     : unary_op_variable_resolve;    break;
		case     "+"     : binary_op_add;                break;
		case     "*"     : binary_op_multiply;           break;
		case     "/"     : binary_op_divide;             break;
		case     "%"     : binary_op_modulo;             break;
		case     "."     : unary_op_io_print;            break;
		case     "pop"   : unary_op_stack_pop;           break;
		case     "dup"   : unary_op_stack_dup;           break;
		case     "swp"   : binary_op_stack_swp;          break;
		case     "true"  : nullary_op_value_bool(true);  break;
		case     "false" : nullary_op_value_bool(false); break;
		case     "<"     : binary_cond_lt;               break;
		case     "="     : binary_cond_eq;               break;
		default          : return false;
	}

	return true;
}

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

void binary_op_add() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	stack.push(a + b);
}

void binary_op_multiply() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	stack.push(a * b);
}

void binary_op_divide() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	if ( b == 0 ) {
		throw new Exception("division by 0 undefined");
	} else {
		stack.push(a / b);
	}
}

void binary_op_modulo() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	if ( b == 0 ) {
		throw new Exception("modulo 0 undefined");
	} else {
		stack.push(a % b);
	}
}

void unary_op_io_print() {
	writeln(stack.top);
}

void unary_op_stack_pop() {
	stack.pop;
}

void unary_op_stack_dup() {
	stack.push(stack.top);
}

void binary_op_stack_swp() {
	auto b = stack.pop;
	auto a = stack.pop;

	stack.push(b);
	stack.push(a);

}

void binary_cond_lt() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	stack.push(a < b);
}

void binary_cond_eq() {
	auto b = stack.pop;
	auto a = stack.pop;

	stack.push(a == b);
}

void nullary_op_value_bool(bool value) {
	stack.push(Token(value));
}
