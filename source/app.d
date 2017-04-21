import std.conv      : to;
import std.string    : split;
import std.range     : dropOne;
import std.algorithm : map, each;
import std.stdio     : stdin, File;

static import machine;

void process(string line) {
	line.split.each!(machine.process);
}

void process(ref File file) {
	file.byLine.map!(to!string).each!process;
}

void main(string[] args) {
	args
		.dropOne
		.map!File
		.each!((File file) => file.process);

	stdin.process;
}
