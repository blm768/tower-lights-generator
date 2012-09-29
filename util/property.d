module util.property;

mixin template reader(string name) {
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
