module primitives.eval;

import std.variant;

import base.stack;
import primitives.core;
import conditional = primitives.conditional;

bool evaluate_primitive(string word) {
	switch ( word ) {
		case     "§"     : definition_start;           break;
		case     "$"     : binary_op_variable_bind;    break;
		case     "@"     : unary_op_variable_resolve;  break;
		case     "if"    : conditional.eval_if;        break;
		case     "then"  : conditional.eval_then;      break;
		case     "else"  : conditional.eval_else;      break;
		case     "+"     : binary_op_add;              break;
		case     "*"     : binary_op_multiply;         break;
		case     "/"     : binary_op_divide;           break;
		case     "%"     : binary_op_modulo;           break;
		case     "."     : unary_op_io_print;          break;
		case     "pop"   : unary_op_stack_pop;         break;
		case     "dup"   : unary_op_stack_dup;         break;
		case     "swp"   : binary_op_stack_swp;        break;
		case     "true"  : integral_value_bool(true);  break;
		case     "false" : integral_value_bool(false); break;
		case     "<"     : binary_cond_lt;             break;
		case     "="     : binary_cond_eq;             break;
		default          : return false;
	}

	return true;
}

bool evaluate(Token token) {
	if ( conditional.drop(token) ) {
		return true;
	} else {
		return token.visit!(
			(int    value) => false,
			(bool   value) => false,
			(string word ) => evaluate_primitive(word)
		);
	}
}

Stack!Token result() {
	if ( conditional.dischargeable ) {
		return conditional.discharge;
	} else {
		return Stack!Token();
	}
}
