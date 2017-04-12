module src.primitives.eval;

import src.primitives.impl;

bool evaluate(int value) {
	return drop_mode;
}

bool evaluate(string word) {
	if ( drop_mode ) {
		if ( word == "then" ) {
			return conditional_end;
		} else {
			return true;
		}
	}

	switch ( word ) {
		case "§":
			return definition_start;
		case "$":
			return binary_op_variable_bind;
		case "@":
			return unary_op_variable_resolve;
		case "if":
			return conditional_start;
		case "then":
			return conditional_end;
		case "+":
			return binary_op_add;
		case "*":
			return binary_op_multiply;
		case "/":
			return binary_op_divide;
		case "%":
			return binary_op_modulo;
		case ".":
			return unary_op_io_print;
		case "pop":
			return unary_op_stack_pop;
		case "dup":
			return unary_op_stack_dup;
		case "swp":
			return binary_op_stack_swp;
		default:
			return false;
	}
}
