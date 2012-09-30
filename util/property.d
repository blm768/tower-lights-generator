module util.property;

mixin template reader(string name) {
	//To do: if this function is defined elswhere with an
	//explicit type, the program crashes.
	//File bug?
	mixin("
		@property auto " ~ name ~ "() {
			return _" ~ name ~ ";
		}"
	);
}

mixin template writer(string name) {
	mixin("
		@property void " ~ name ~ "(" ~ typeof(mixin("_" ~ name)).stringof ~ " value) {
			_" ~ name ~ " = value;
		}"
	);
}
