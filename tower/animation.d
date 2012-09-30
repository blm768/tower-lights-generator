module tower.animation;

import std.algorithm;
import std.array;
import std.conv;
public import std.datetime;
import std.stdio;
import std.string;

import util.property;

public import tower.color;

class Animation {
	this(size_t width, size_t height) {
		_width = width;
		_height = height;
	}

	void writeV3File(string filename) {
		//Open file.
		auto file = File(filename, "w");
		//Write version.
		file.writeln("0.3");
		for(size_t i = 0; i < 3; ++i) {
			write(file, Color(255, 255, 255));
		}
		file.writeln();
		//Write dummy palette data.
		for(size_t i = 0; i < 2; ++i) {
			for(size_t j = 0; j < 18; ++j) {
				write(file, Color(255, 255, 255));
			}
			file.writeln();
		}
		//Write metrics.
		file.writeln(frames.length, " ", height, " ", width, " ");
		//Write frames.
		Duration time;
		foreach(Frame f; frames) {
			f.writeV3(file, time);
		}
	}

	@property size_t width() {
		return _width;
	}

	@property size_t height() {
		return _height;
	}

	Frame[] frames;

	private:
	size_t _width, _height;

	void write(File f, Color c) {
		foreach(string s; c.values[].map!(a => to!string(a))) {
			f.write(s, " ");
		}
	}
}

struct Point {
	size_t x, y;
}

struct ColoredPoint {
	Point position;
	alias position this;
	Color color;
}

/++
Represents a frame of an animation
+/
struct Frame {
	this(Animation a) {
		_width = a.width;
		_height = a.height;
		data.length = width * height;
	}

	ref Color opIndex(size_t x, size_t y) {
		assert(x < width && y < height);
		return data[x + y * width];
	}

	ref Color opIndex(Point p) {
		return opIndex(p.x, p.y);
	}

	Duration duration;

	mixin reader!"width";
	mixin reader!"height";

	protected:
	void writeV3(File file, ref Duration time) {
		//Write start time.
		file.writefln("%2.2d:%2.2d.%3.3d", time.minutes, time.seconds, time.fracSec.msecs);
		for(size_t row = 0; row < height; ++row) {
			Color[] rowData = data[row * width .. (row + 1) * width];
			//To do: coverage shows a whole lot of hits here. Is that a DMD bug?
			file.writeln(rowData.map!(a => a.values[].map!(b => b.to!string).join(" ")).join(" "));
		}
		time += duration;
	}

	private:
	Color[] data;

	size_t _width, _height;
}

