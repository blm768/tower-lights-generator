module tower.color;

import std.conv;
import std.math;
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

	static Color hsv(float h, float s, float v) {
		//To do: make sure parameters are in the correct range.
		if(h.isNaN) {
			return Color(0, 0, 0);
		}
		float[3] rgb;
		float chroma = v * s;
		float hPrime = h * 6;
		float x = chroma * (1 - abs((hPrime % 2) - 1));

		if(hPrime < 1) {
			rgb = [chroma, x, 0];
		} else if(hPrime < 2) {
			rgb = [x, chroma, 0];
		} else if(hPrime < 3) {
			rgb = [0, chroma, x];
		} else if(hPrime < 4) {
			rgb = [0, x, chroma];
		} else if(hPrime < 5) {
			rgb = [x, 0, chroma];
		} else {
			rgb = [chroma, 0, x];
		}

		rgb[] += v - chroma;
		rgb[] *= 255;

		Color result;
		result.values[] = rgb.to!(ubyte[]);
		return result;
	}
}

unittest{
	Color a = Color(255, 255, 255), b = Color(0, 0, 0);
	assert(a.blend(b, 0.5) == Color(127, 127, 127));
}
