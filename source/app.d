import std.string    : split;
import std.range     : dropOne;
import std.algorithm : map, each;
import std.stdio     : stdin, File, lines;

static import machine;

void process(ref File file) {
	foreach ( string line; lines(file) ) {
		line.split.each!(machine.process);
	}
}

void main(string[] args) {
	args
		.dropOne
		.map!(File)
		.each!((File file) => file.process);

	while ( !stdin.eof ) {
		stdin.readln.split.each!(machine.process);
	}
}
