module tower.generator;

import std.array;
import std.random;
import std.stdio;

import util.list;
import util.property;

public import tower.animation;

/++
Generates frames to be placed into an animation
+/
abstract class Generator {
	/++
	Creates a generator suitable for use with the given animation
	+/
	this(Animation animation) {
		_animation = animation;
	}

	///Generates a single frame
	Frame generate();

	///Generates an array of frames
	Frame[] generate(size_t numFrames) {
		auto frames = uninitializedArray!(Frame[])(numFrames);
		for(size_t i = 0; i < numFrames; ++i) {
			frames[i] = generate();
		}
		return frames;
	}

	///The animation for which this generator is used
	mixin reader!"animation";

	private:
	Animation _animation;
}

/++
Generates random colors to be used with a Generator
+/
abstract class ColorGenerator {
	alias uniform!("[]", ubyte, ubyte) uniformUbyte;
	Color generate();
}

class SnowGenerator: Generator {
	this(Animation a, ColorGenerator c = new RandomHueGenerator) {
		super(a);
		cGen = c;
	}

	override Frame generate() {
		auto f = Frame(animation);
		f.duration = dur!"msecs"(500);
		//Should a point be generated?
		if(uniform(0, 3) == 0) {
			auto point = ColoredPoint();
			//Overflow makes this work out quite nicely.
			//To do: I should probably use signed ints.
			point.position = Point(uniform(0, f.width - 1), size_t.max);
			point.color = cGen.generate();
			points.insertFront(point);
		}
		//Loop over the points.
		foreach(ref node; points.nodes) {
			ColoredPoint* point = &node.value;
			point.y += 1;
			if(point.y >= f.height) {
				points.remove(node);
			} else {
				f[*point] = point.color;
			}
		}
		return f;
	}

	//Pull in the superclass's overloaded version of generate().
	alias super.generate generate;

	///A doubly-linked list of "flakes"
	DList!ColoredPoint points;
	ColorGenerator cGen;

}

class RandomColorGenerator: ColorGenerator {
	override Color generate() {
		return Color(uniformUbyte(0, 255), uniformUbyte(0, 255), uniformUbyte(0, 255));
	}
}

class RandomHueGenerator: ColorGenerator {
	override Color generate() {
		return Color.hsv(uniform(0.0, 1.0), 1.0, 1.0);
	}
}
