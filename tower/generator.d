module tower.generator;

import std.array;
import std.random;
import std.stdio;

import util.list;
import util.property;

public import tower.animation;

alias Frame delegate(Animation a) Generator;

alias Color delegate() ColorGenerator;

///Generates an array of frames
void generate(Animation a, Generator gen, size_t numFrames) {
	auto frames = uninitializedArray!(Frame[])(numFrames);
	for(size_t i = 0; i < numFrames; ++i) {
		frames[i] = gen(a);
	}
	a.frames ~= frames;
}


alias uniform!("[]", ubyte, ubyte) uniformUbyte;

Generator constantFrame(Duration d, Color c) {
	Frame generate(Animation a) {
		Frame f = Frame(a);
		f.duration = d;
		for(size_t y = 0; y < a.height; ++y) {
			for(size_t x = 0; x < a.width; ++x) {
				f[x, y] = c;
			}
		}
		return f;
	}
	return &generate;
}

Generator snow(Duration d, size_t fallFrames, size_t framesPerNewPoint, ColorGenerator cGen = randomHue) {
	size_t currentFrame = 0;
	//A doubly-linked list of "flakes"
	DList!ColoredPoint points;
	Frame generate(Animation a) {
		auto f = Frame(a);
		f.duration = d;
		//Should a point be generated?
		if(currentFrame < fallFrames && uniform(1, 3) == 1) {
			auto point = ColoredPoint();
			//Overflow makes this work out quite nicely.
			//To do: I should probably use signed ints.
			point.position = Point(uniform(0, f.width - 1), size_t.max);
			point.color = cGen();
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
		++currentFrame;
		return f;
	}
	return &generate;
}

Generator zip(Duration d, Color l, Color r) {
	size_t currentFrame = 0;
	Frame generate(Animation a) {
		Frame f = Frame(a);
		f.duration = d;
		for(size_t y = 0; y < a.height; y += 2) {
			for(size_t x = 0; x < currentFrame; ++x) {
				f[x, y] = l;
			}
		}
		for(size_t y = 1; y < a.height; y += 2) {
			for(int x = a.width - 1; x >= cast(int)(a.width - currentFrame); --x) {
				f[x, y] = r;
			}
		}
		if(currentFrame < a.width) {
			++currentFrame;
		}
		return f;
	}
	return &generate;
}

Generator wave(Duration d, float period, float velocity) {
	float t = 0;
	Frame generate(Animation a) {
		auto f = Frame(a);
		f.duration = d;

		return f;
	}
	return &generate;
}

Generator mix(Duration d, Generator g1, Generator g2, float fac0, float fac1, size_t frames) {
	float factor = fac0;
	float step = (fac1 - fac0) / cast(float)frames;
	size_t frame = 0;
	Frame generate(Animation a) {
		Frame f = g1(a);
		f.duration = d;
		Frame second = g2(a);
		for(size_t y = 0; y < a.height; ++y) {
			for(size_t x = 0; x < a.width; ++x) {
				f[x, y] = f[x, y].blend(second[x, y], factor);
			}
		}
		++frame;
		if(frame < frames)
			{factor += step;}
		return f;
	}
	return &generate;
}

ColorGenerator constant(Color c) {
	Color generate() {
		return c;
	}
	return &generate;
}

ColorGenerator random() {
	Color generate() {
		return Color(uniformUbyte(0, 255), uniformUbyte(0, 255), uniformUbyte(0, 255));
	}
	return &generate;
}

ColorGenerator randomHue() {
	Color generate() {
		return Color.hsv(uniform(0.0, 1.0), 1.0, 1.0);
	}
	return &generate;
}
