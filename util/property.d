module util.property;

public import core.exception;

//To do: move check to static assertion?
mixin template reader(alias sym) if(sym.stringof[0] == '_') {
	//To do: if this function is defined elswhere with an
	//explicit type, the program crashes.
	//File bug?
	mixin("
		@property auto " ~ sym.stringof[1 .. $] ~ "() {
			return " ~ sym.stringof ~ ";
		}"
	);
}

mixin template writer(alias sym) if(sym.stringof[0] == '_') {
	mixin("
		@property void " ~ sym.stringof[1 .. $] ~ "(" ~ typeof(sym).stringof ~ " value) {
			" ~ sym.stringof ~ " = value;
		}"
	);
}

mixin template validatingWriter(alias sym, string expr) if(sym.stringof[0] == '_') {
	mixin("
		@property void " ~ sym.stringof[1 .. $] ~ "(" ~ typeof(sym).stringof ~ " value) {
			if(!(" ~ expr ~ ")) {
				throw new RangeError;
			}
			" ~ sym.stringof ~ " = value;
		}"
	);
}

mixin template property(alias sym) if(sym.stringof[0] == '_') {
	mixin reader!sym;
	mixin writer!sym;
}

mixin template validatingProperty(alias sym, string expr) if(sym.stringof[0] == '_') {
	mixin reader!sym;
	mixin validatingWriter!(sym, expr);
}
