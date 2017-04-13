module src.primitives.eval;

import src.primitives.impl;

bool evaluate(int value) {
	return drop_mode;
}

bool evaluate(bool value) {
	return drop_mode;
}

bool evaluate(string word) {
	if ( drop_mode ) {
		switch ( word ) {
			case "then":
				return n_ary_conditional_then;
			case "else":
				return n_ary_conditional_else;
			default:
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
			return unary_conditional_if;
		case "then":
			return n_ary_conditional_then;
		case "else":
			return n_ary_conditional_else;
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
		case "true":
			return integral_value_bool(true);
		case "false":
			return integral_value_bool(false);
		case "<":
			return binary_cond_lt;
		case "=":
			return binary_cond_eq;
		default:
			return false;
	}
}
