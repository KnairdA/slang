module src.primitives;

import std.stdio;

import src.stack;
import src.definition;

int[string] variables;

bool evaluate(string word) {
	switch ( word ) {
		case "§":
			src.definition.start;
			return true;
		case "$":
			string name  = stack.pop.get!string;
			int    value = stack.pop.get!int;

			variables[name] = value;
			return true;
		case "@":
			string name = stack.pop.get!string;

			if ( name in variables ) {
				stack.push(variables[name]);
			}
			return true;
		case "+":
			int b = stack.pop.get!int;
			int a = stack.pop.get!int;

			stack.push(a + b);
			return true;
		case "*":
			int b = stack.pop.get!int;
			int a = stack.pop.get!int;

			stack.push(a * b);
			return true;
		case "/":
			int b = stack.pop.get!int;
			int a = stack.pop.get!int;

			if ( b == 0 ) {
				throw new Exception("division by 0 undefined");
			} else {
				stack.push(a / b);
			}
			return true;
		case "%":
			int b = stack.pop.get!int;
			int a = stack.pop.get!int;

			if ( b == 0 ) {
				throw new Exception("modulo 0 undefined");
			} else {
				stack.push(a % b);
			}
			return true;
		case ".":
			stack.pop;
			return true;
		case "'":
			writeln(stack.top);
			return true;
		default:
			return false;
	}
}
