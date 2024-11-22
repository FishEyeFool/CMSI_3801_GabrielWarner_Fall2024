// A class for an expandable stack. There is already a stack class in the
// Standard C++ Library; this class serves as an exercise for students to
// learn the mechanics of building generic, expandable, data structures
// from scratch with smart pointers.

#include <stdexcept>
#include <string>
#include <memory>
using namespace std;

// A stack object wraps a low-level array indexed from 0 to capacity-1 where
// the bottommost element (if it exists) will be in slot 0. The member top is
// the index of the slot above the top element, i.e. the next available slot
// that an element can go into. Therefore if top==0 the stack is empty and
// if top==capacity it needs to be expanded before pushing another element.
// However for security there is still a super maximum capacity that cannot
// be exceeded.

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
  // Add three fields: elements, a smart pointer to the array of elements,
  // capacity, the current capacity of the array, and top, the index of the
  // next available slot in the array.
  unique_ptr<T[]> elements;
  int capacity;
  int top;


  // Prohibit copying and assignment
  Stack(const Stack<T>&) = delete;
  Stack<T>& operator=(const Stack<T>&) = delete; 
  
public:
  // Write your stack constructor here
  Stack():
    top(0),
    capacity(INITIAL_CAPACITY),
    elements(make_unique<T[]>(INITIAL_CAPACITY)) {
    }


  // Write your size() method here
  int size() const {
    return top;
  }

  // Write your is_empty() method here
  bool is_empty() const {
    return top == 0;
  }

  // Write your is_full() method here

  // Write your push() method here
  void push(T item) {
    if (top == MAX_CAPACITY) {
      throw overflow_error("Stack has reached maximum capacity");
    }
    if (top == capacity) {
      reallocate(2 * capacity);
    }
    elements[top++] = item;
  }

  // Write your pop() method here
  T pop() {
    if (is_empty()) {
      throw underflow_error("cannot pop from empty stack");
    }
    if (top <= capacity / 4) {
      reallocate(capacity / 2);
    }
    // TODO: get the top element, pop it
    //       overwrite the top element with the default value (for security)
    //       return the top element 
  }

private:
  // We recommend you make a PRIVATE reallocate method here. It should
  // ensure the stack capacity never goes above MAX_CAPACITY or below
  // INITIAL_CAPACITY. Because smart pointers are involved, you will need
  // to use std::move() to transfer ownership of the new array to the stack
  // after (of course) copying the elements from the old array to the new
  // array with std::copy().
  void reallocate(int new_capacity) {
    
  }

};
