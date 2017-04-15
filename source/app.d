import std.string : split;
import std.stdio  : stdin, readln, writeln;

static import machine;

void main() {
	while ( !stdin.eof ) {
		foreach ( token; stdin.readln.split ) {
			machine.process(token);
		}
	}
}
