module main;

import std.stdio;
import std.string;

import tower.generator;

int main(string[] args) {
	auto a = new Animation(4, 10);
	auto gen = new SnowGenerator(a);
	a.frames ~= gen.generate(5);
	a.writeV3File("test.tan");
    return 0;
}
