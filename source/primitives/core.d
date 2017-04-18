module primitives.core;

import std.stdio;
import std.variant;

import state.stack;

bool handle(Token token) {
	return token.visit!(
		(int        ) => false,
		(bool       ) => false,
		(string word) => handle(word)
	);
}

private {

bool handle(string word) {
	switch ( word ) {
		case     "+"     : binary_op_add;                break;
		case     "*"     : binary_op_multiply;           break;
		case     "/"     : binary_op_divide;             break;
		case     "%"     : binary_op_modulo;             break;
		case     "."     : unary_op_io_print;            break;
		case     "pop"   : unary_op_stack_pop;           break;
		case     "dup"   : unary_op_stack_dup;           break;
		case     "swp"   : binary_op_stack_swp;          break;
		case     "ovr"   : binary_op_stack_ovr;         break;
		case     "rot"   : ternary_op_stack_rot;         break;
		case     "true"  : nullary_op_value_bool(true);  break;
		case     "false" : nullary_op_value_bool(false); break;
		case     "not"   : unary_op_negate;              break;
		case     "and"   : binary_cond_and;              break;
		case     "or"    : binary_cond_or;               break;
		case     "<"     : binary_cond_lt;               break;
		case     "="     : binary_cond_eq;               break;
		case     "#"     : debug_print_stack;            break;
		default          : return false;
	}

	return true;
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

void binary_op_stack_ovr() {
	auto b = stack.pop;
	auto a = stack.pop;

	stack.push(a);
	stack.push(b);
	stack.push(a);
}

void ternary_op_stack_rot() {
	auto c = stack.pop;
	auto b = stack.pop;
	auto a = stack.pop;

	stack.push(b);
	stack.push(c);
	stack.push(a);
}

void nullary_op_value_bool(bool value) {
	stack.push(Token(value));
}

void unary_op_negate() {
	bool a = stack.pop.get!bool;

	stack.push(Token(!a));
}

void binary_cond_and() {
	bool b = stack.pop.get!bool;
	bool a = stack.pop.get!bool;

	stack.push(Token(a && b));
}

void binary_cond_or() {
	bool b = stack.pop.get!bool;
	bool a = stack.pop.get!bool;

	stack.push(Token(a || b));
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

void debug_print_stack() {
	writeln(stack[]);
}

}
