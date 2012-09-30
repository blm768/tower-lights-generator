module main;

import std.stdio;
import std.string;

import tower.generator;

//To do: use contracts!

int main(string[] args) {
	auto a = new Animation(4, 10);
	auto gen = new SnowGenerator(a, 1);
	a.frames ~= gen.generate(20);
	a.writeV3File("test.tan");
    return 0;
}
