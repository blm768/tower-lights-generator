module tower.color;

import std.conv;
debug import std.stdio;

struct Color {
	union {
		struct {
			ubyte r, g, b;
		}
		ubyte[3] values;
	}

	//To do: optimize?
	Color blend(Color other, float factor) {
		assert(factor >= 0.0 && factor <= 1.0);
		float[3] floatValues = values.to!(float[])[] * (1 - factor);
		floatValues[] += other.values.to!(float[])[] * factor;
		Color result;
		result.values[] = floatValues.to!(ubyte[]);
		return result;
	}
}

unittest{
	Color a = Color(255, 255, 255), b = Color(0, 0, 0);
	assert(a.blend(b, 0.5) == Color(127, 127, 127));
}
