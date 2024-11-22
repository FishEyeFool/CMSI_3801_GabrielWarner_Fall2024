/// A generic `Stack` implementation using a `Vec` as the underlying storage.
///
/// The `Stack` struct provides standard stack operations:
/// - Push: Add an element to the top of the stack.
/// - Pop: Remove and return the element from the top of the stack.
/// - Peek: View the element at the top of the stack without removing it.
/// - Check if the stack is empty.
/// - Get the number of elements in the stack.
pub struct Stack<T> {
    // stack items are private by default
    items: Vec<T>,
}

impl<T> Stack<T> {
    /// Creates a new, empty `Stack`.
    pub fn new() -> Self {
        Stack { items: Vec::new() }
    }

    /// Pushes an item onto the top of the stack.
    ///
    /// # Arguments
    ///
    /// * `item` - The item to be pushed onto the stack.
    pub fn push(&mut self, item: T) {
        self.items.push(item);
    }

    /// Removes and returns the item at the top of the stack.
    ///
    /// Returns `None` if the stack is empty.
    pub fn pop(&mut self) -> Option<T> {
        self.items.pop()
    }

    /// Returns a reference to the item at the top of the stack without removing it.
    ///
    /// Returns `None` if the stack is empty.
    pub fn peek(&self) -> Option<&T> {
        self.items.last()
    }

    /// Checks if the stack is empty.
    ///
    /// Returns `true` if the stack is empty, otherwise `false`.
    pub fn is_empty(&self) -> bool {
        self.items.is_empty()
    }

    /// Returns the number of items in the stack.
    pub fn len(&self) -> usize {
        self.items.len()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_push_and_pop() {
        let mut stack: Stack<i32> = Stack::new();
        assert!(stack.is_empty());
        stack.push(1);
        stack.push(2);
        assert_eq!(stack.len(), 2);
        assert_eq!(stack.pop(), Some(2));
        assert_eq!(stack.pop(), Some(1));
        assert_eq!(stack.pop(), None);
        assert!(stack.is_empty());
    }

    #[test]
    fn test_peek() {
        let mut stack: Stack<i32> = Stack::new();
        assert_eq!(stack.peek(), None);
        stack.push(3);
        assert_eq!(stack.peek(), Some(&3));
        stack.push(5);
        assert_eq!(stack.peek(), Some(&5));
    }

    #[test]
    fn test_is_empty() {
        let mut stack: Stack<String> = Stack::new();
        assert!(stack.is_empty());
        stack.push(String::from("hello"));
        assert!(!stack.is_empty());
        stack.pop();
        assert!(stack.is_empty());
    }

    #[test]
    fn test_stacks_cannot_be_cloned_or_copied() {
        let stack1: Stack<i32> = Stack::new();
        let _stack2: Stack<i32> = stack1;
        // Should get a compile error if next line uncommented
        // let _stack3: Stack<i32> = stack1; // Error: `stack1` has been moved
    }
}
