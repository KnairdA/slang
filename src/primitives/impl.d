module src.primitives.impl;

import std.stdio;

import src.stack;
import src.definition;

Token[string] variables;
bool          drop_mode;

bool definition_start() {
	src.definition.start;
	return true;
}

bool binary_op_variable_bind() {
	string name  = stack.pop.get!string;
	Token  value = stack.pop;

	variables[name] = value;
	return true;
}

bool unary_op_variable_resolve() {
	string name = stack.pop.get!string;

	if ( name in variables ) {
		stack.push(variables[name]);
	}

	return true;
}

bool conditional_if() {
	drop_mode = !stack.pop.get!bool;
	return true;
}

bool conditional_then() {
	drop_mode = !drop_mode;
	return true;
}

bool conditional_else() {
	drop_mode = false;
	return true;
}

bool binary_op_add() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	stack.push(a + b);

	return true;
}

bool binary_op_multiply() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	stack.push(a * b);

	return true;
}

bool binary_op_divide() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	if ( b == 0 ) {
		throw new Exception("division by 0 undefined");
	} else {
		stack.push(a / b);
	}

	return true;
}

bool binary_op_modulo() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	if ( b == 0 ) {
		throw new Exception("modulo 0 undefined");
	} else {
		stack.push(a % b);
	}

	return true;
}

bool unary_op_io_print() {
	writeln(stack.top);
	return true;
}

bool unary_op_stack_pop() {
	stack.pop;
	return true;
}

bool unary_op_stack_dup() {
	stack.push(stack.top);
	return true;
}

bool binary_op_stack_swp() {
	auto b = stack.pop;
	auto a = stack.pop;

	stack.push(b);
	stack.push(a);

	return true;
}

bool binary_cond_lt() {
	int b = stack.pop.get!int;
	int a = stack.pop.get!int;

	stack.push(a < b);
	return true;
}

bool binary_cond_eq() {
	auto b = stack.pop;
	auto a = stack.pop;

	stack.push(a == b);
	return true;
}

bool integral_value_bool(bool value) {
	stack.push(Token(value));
	return true;
}
