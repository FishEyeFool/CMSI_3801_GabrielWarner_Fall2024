/**
 * @class Stack
 * @brief A dynamic, resizable stack implementation with a fixed maximum capacity.
 *
 * This templated stack class provides typical stack operations such as push, pop, and size, 
 * while dynamically adjusting its internal storage capacity to optimize memory usage.
 * 
 * @tparam T The type of elements to store in the stack.
 *
 * ## Key Features:
 * - **Dynamic Resizing**: The stack automatically grows and shrinks its internal storage as needed, 
 *   maintaining efficiency while respecting the maximum capacity.
 * - **Capacity Limits**: The stack starts with an initial capacity and can grow up to a defined 
 *   maximum capacity.
 * - **Exception Safety**: Provides strong exception guarantees for invalid operations 
 *   (e.g., pushing onto a full stack or popping from an empty stack).
 *
 * ## Constraints:
 * - Copy constructor and assignment operator are deleted to prevent accidental copying 
 *   and to ensure resource management integrity.
 *
 * ## Public Methods:
 * - `Stack()`: Constructs an empty stack with an initial capacity.
 * - `int size() const`: Returns the current number of elements in the stack.
 * - `bool is_empty() const`: Checks if the stack is empty.
 * - `bool is_full() const`: Checks if the stack is full.
 * - `void push(T item)`: Adds an item to the top of the stack. Throws `std::overflow_error` 
 *   if the stack exceeds its maximum capacity.
 * - `T pop()`: Removes and returns the item at the top of the stack. Throws `std::underflow_error` 
 *   if the stack is empty.
 *
 * ## Private Methods:
 * - `void reallocate(int new_capacity)`: Resizes the internal storage to the specified capacity, 
 *   constrained by the defined maximum and initial capacities.
 *
 * ## Constants:
 * - `MAX_CAPACITY`: The maximum allowed capacity of the stack (32,768 by default).
 * - `INITIAL_CAPACITY`: The initial capacity of the stack (16 by default).
*/

#include <stdexcept>
#include <string>
#include <memory>
using namespace std;


#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
  unique_ptr<T[]> elements;
  int capacity;
  int top;

  Stack(const Stack<T>&) = delete;
  Stack<T>& operator=(const Stack<T>&) = delete; 
  
public:
  Stack():
    top(0),
    capacity(INITIAL_CAPACITY),
    elements(make_unique<T[]>(INITIAL_CAPACITY)) {
    }

  int size() const {
    return top;
  }

  bool is_empty() const {
    return top == 0;
  }

  bool is_full() const {
    return top == capacity;
  }

  void push(T item) {
    if (top == MAX_CAPACITY) {
      throw overflow_error("Stack has reached maximum capacity");
    }
    if (top == capacity) {
      reallocate(2 * capacity);
    }
    elements[top++] = item;
  }

  T pop() {
    if (is_empty()) {
      throw underflow_error("cannot pop from empty stack");
    }
    T popped_value = elements[--top];
    elements[top] = T();
    if (top <= capacity / 4 && capacity / 2 >= INITIAL_CAPACITY) {
      reallocate(max(capacity / 2, INITIAL_CAPACITY));
    }
    return popped_value;
  }

private:
  void reallocate(int new_capacity) {
    new_capacity = max(INITIAL_CAPACITY, min(new_capacity, MAX_CAPACITY));
    unique_ptr<T[]> new_elements = make_unique<T[]>(new_capacity);
    copy(&elements[0], &elements[top], &new_elements[0]);
    elements = move(new_elements);
    capacity = new_capacity;
  }
};
