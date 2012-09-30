/++
Utilities for linked-list node trees

This code may be very loosely based on some of the stuff in Phobos.
+/
module util.list;

import core.exception;

import util.property;

struct DList(T) {
	//To do: optimize?
	@property T front() {
		return this[].front;
	}

	void insertFront(T value) {
		auto n = new Node(value, null, head);
		if(head) {
			head.prev = n;
		} else {
			tail = n;
		}
		head = n;
		++_length;
	}

	@property T back() {
		return this[].back;
	}

	void removeFront() {
		if(!head) {
			throw new RangeError;
		}
		head = head.next;
		if(head) {
			head.prev = null;
		} else {
			tail = null;
		}
		--_length;
	}

	void removeBack() {
		if(!tail) {
			throw new RangeError;
		}
		tail = tail.prev;
		if(tail) {
			tail.next = null;
		} else {
			head = null;
		}
		--_length;
	}

	/+void remove(Range r) {
		assert(false);
	}+/

	void remove(ref Node n) {
		if(!n.prev) {
			removeFront();
		} else if(!n.next) {
			removeBack();
		} else {
			n.prev.next = n.next;
			n.next.prev = n.prev;
			--_length;
		}
	}

	Range opSlice() {
		return Range(head, tail);
	}

	Range opSlice(size_t start, size_t end) {
		//To do: configure use of range checks?
		if(start > end) {
			throw new RangeError;
		}
		if(start >= length || end > length) {
			throw new RangeError;
		}
		if(start == end) {
			return Range(null, null);
		}
		Range r = Range(head, null);
		for(size_t i = 0; i < start; ++i) {
			r.head = r.head.next;
		}
		r.tail = r.head;
		for(size_t i = start; i < end - 1; ++i) {
			r.tail = r.tail.next;
		}
		return r;
	}

	@property NodeRange nodes() {
		return NodeRange(head, tail);
	}

	struct Range {
		@property T front() {
			if(!head) {
				throw new RangeError;
			}
			return head.value;
		}

		T popFront() {
			if(!head) {
				throw new RangeError;
			}
			Node* tmp = head;
			if(tail == head) {
				head = null;
				tail = null;
			} else {
				head = head.next;
			}
			return tmp.value;
		}

		@property T back() {
			if(!tail) {
				throw new RangeError;
			}
			return tail.value;
		}

		T popBack() {
			if(!tail) {
				throw new RangeError;
			}
			Node* tmp = tail;
			if(tail == head) {
				head = null;
				tail = null;
			} else {
				tail = tail.prev;
			}
			return tmp.value;
		}

		@property bool empty() {
			return !head;
		}

		private:
		Node* head, tail;
	}

	struct NodeRange {
		@property ref Node front() {
			return *head;
		}

		ref Node popFront() {
			if(!head) {
				throw new RangeError;
			}
			Node* tmp = head;
			if(tail == head) {
				head = null;
				tail = null;
			} else {
				head = head.next;
			}
			return *tmp;
		}

		@property ref Node back() {
			return *tail;
		}

		ref Node popBack() {
			if(!tail) {
				throw new RangeError;
			}
			Node* tmp = tail;
			if(tail == head) {
				head = null;
				tail = null;
			} else {
				tail = tail.prev;
			}
			return *tmp;
		}

		@property bool empty() {
			return !head;
		}

		private:
		Node* head, tail;
	}

	struct Node {
		//Why is this needed for new?
		this(T value, Node* prev, Node* next) {
			this.value = value;
			this.prev = prev;
			this.next = next;
		}
		T value;
		Node* prev, next;
	}

	mixin reader!_length;

	private:
	Node* head, tail;
	size_t _length;
}

unittest {
	DList!size_t test;
	test.insertFront(0);
	assert(test.length == 1);
	assert(test.front == 0);
	assert(test.back == 0);
	assert(test.head == test.tail);
	test.removeFront();
	assert(test.length == 0);
	assert(test.head == null);
	assert(test.tail == null);

	test.insertFront(3);
	test.insertFront(2);
	test.insertFront(1);
	test.insertFront(0);

	size_t sum = 0;
	foreach_reverse(size_t num; test) {
		sum += num;
	}
	assert(sum == 6);

	sum = 0;
	foreach(size_t num; test) {
		sum += num;
	}
	assert(sum == 6);

	sum = 0;
	foreach(size_t num; test[1 .. 3]) {
		sum += num;
	}
	assert(sum == 3);

	sum = 0;
	foreach(ref n; test.nodes) {
		if(n.value == 1) {
			test.remove(n);
		}
	}
	assert(test.length == 3);

	sum = 0;
	foreach(size_t num; test) {
		sum += num;
	}
	assert(sum == 5);
	assert(test.nodes.front.value == 0);
	assert(test.nodes.front.next.value == 2);
}
