module tower.generator;

import std.array;
import std.random;
import std.stdio;

import util.list;
import util.property;

public import tower.animation;

abstract class Generator {
	this(Animation a) {
		_animation = a;
	}

	Frame generate();

	Frame[] generate(size_t numFrames) {
		auto frames = uninitializedArray!(Frame[])(numFrames);
		for(size_t i = 0; i < numFrames; ++i) {
			frames[i] = generate();
		}
		return frames;
	}

	mixin reader!"animation";

	private:
	Animation _animation;
}

class SnowGenerator: Generator {
	this(Animation a) {
		super(a);

		points.insertFront(Point(0, 0));
	}

	override Frame generate() {
		auto f = Frame(animation);
		f.duration = dur!"msecs"(500);
		//Should a point be generated?
		if(uniform(0, 3) == 0) {
			//Overflow makes this work out quite nicely.
			//To do: I should probably use signed ints.
			points.insertFront(Point(uniform(0, f.width - 1), size_t.max));
		}
		//Loop over the points.
		foreach(ref node; points.nodes) {
			Point* point = &node.value;
			point.y += 1;
			if(point.y >= f.height) {
				points.remove(node);
			} else {
				f[*point] = Color(255, 255, 255);
			}
		}
		return f;
	}

	alias super.generate generate;

	DList!Point points;
}
