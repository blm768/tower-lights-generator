module main;

import std.stdio;
import std.string;

import tower.animation;

int main(string[] args) {
	auto animation = new Animation;
	animation.writeV3File("test.tan");
	auto file = File("../../test.tan");
	foreach(const(char)[] line; file.byLine) {
		writeln(line.strip.split(" ").length);
	}
    return 0;
}
