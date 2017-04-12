module src.primitives.impl;

import std.stdio;

import src.stack;
import src.definition;

int[string] variables;
bool        drop_mode;

bool definition_start() {
	src.definition.start;
	return true;
}

bool binary_op_variable_bind() {
	string name  = stack.pop.get!string;
	int    value = stack.pop.get!int;

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

bool conditional_start() {
	switch ( stack.pop.get!int ) {
		case 0:
			drop_mode = true;
			return true;
		case 1:
			drop_mode = false;
			return true;
		default:
			throw new Exception("invalid logic value");
	}
}

bool conditional_end() {
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
