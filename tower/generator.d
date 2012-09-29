module tower.generator;

import std.array;
import std.container;
import std.random;

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

	@property Animation animation() {
		return animation;
	}

	mixin reader!"animation";

	private:
	Animation _animation;
}

class SnowGenerator: Generator {
	this(Animation a) {
		super(a);
	}

	override Frame generate() {
		return Frame(animation);
	}

	alias super.generate generate;

	DList!Point points;
}
