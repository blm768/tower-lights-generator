module tower.color;

struct Color {
	union {
		struct {
			ubyte r, g, b;
		}
		ubyte[3] values;
	}
}
