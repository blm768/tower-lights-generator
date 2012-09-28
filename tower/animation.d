module tower.animation;

import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;

public import tower.frame;

class Animation {
	this(size_t width, size_t height) {
		_width = width;
		_height = height;
	}

	void writeV3File(string filename) {
		auto file = File(filename, "w");
		file.writeln("0.3");
		for(size_t i = 0; i < 3; ++i) {
			write(file, Color(255, 255, 255));
		}
		file.writeln();
		for(size_t i = 0; i < 2; ++i) {
			for(size_t j = 0; j < 18; ++j) {
				write(file, Color(255, 255, 255));
			}
			file.writeln();
		}
		file.writeln(height, " ", width, " ", numFrames);
		file.close();
		file = File(filename, "r");
		foreach(const(char)[] line; file.byLine) {
			writeln(line.strip.split(" ").length);
		}
	}

	@property size_t width() {
		return _width;
	}

	@property size_t height() {
		return _height;
	}

	@property size_t numFrames() {
		return _numFrames;
	}

	private:
	size_t _width, _height, _numFrames;

	void write(File f, Color c) {
		foreach(string s; c.values[].map!(a => to!string(a))) {
			f.write(s, " ");
		}
	}

	struct Frame {
		this() {
			data.length = width * height;
		}

		Color opIndex(size_t x, size_t y) {
			assert(x < width && y < height);
			return data[x + y * width];
		}

		Color[] data;
	}
}
