module main;

import std.stdio;
import std.string;

import tower.generator;

//To do: use contracts!

int main(string[] args) {
	auto d = dur!"msecs"(500);
	auto a = new Animation(4, 10);
	a.generate(snow(d, 20, 2), 20 + a.height);
	auto zGen = zip(d, Color(255, 0, 0), Color(0, 255, 0));
	a.generate(zGen, 5);
	auto mGen = mix(dur!"msecs"(60), zGen, constantFrame(d, Color(0, 0, 0)), 0.0, 1.0, 30);
	a.generate(mGen, 30);
	a.writeV3File("test.tan");
    return 0;
}
