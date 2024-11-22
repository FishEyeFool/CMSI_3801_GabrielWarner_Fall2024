/**
 * @file string_stack.c
 * @brief Implementation of a dynamic stack for managing strings.
 *
 * This file provides the implementation of a stack data structure specifically designed to manage strings.
 * The stack grows dynamically as needed and supports basic stack operations such as push, pop, and size queries.
 *
 * The stack is internally represented by a structure (`_Stack`) that keeps track of the elements, the current 
 * stack size (`top`), and the allocated capacity. The stack can expand and shrink dynamically based on usage.
 *
 * ## Key Functions
 * - `stack_response create()`: Creates and initializes a new stack.
 * - `int size(const stack s)`: Returns the number of elements currently in the stack.
 * - `bool is_empty(const stack s)`: Checks if the stack is empty.
 * - `bool is_full(const stack s)`: Checks if the stack has reached its maximum allowed capacity.
 * - `response_code push(stack s, char* item)`: Pushes a new string onto the stack. Resizes if needed.
 * - `string_response pop(stack s)`: Removes and returns the string at the top of the stack.
 * - `void destroy(stack* s)`: Frees all resources associated with the stack.
 *
 * ## Error Handling
 * - The stack operations return appropriate error codes for scenarios like memory allocation failure, exceeding 
 *   stack size limits, or attempting operations on an empty stack.
 * - Strings added to the stack are internally duplicated (`strdup`) to ensure ownership is managed by the stack.
*/
#include "string_stack.h"

#include <stdlib.h>
#include <string.h>

#define INITIAL_CAPACITY 16

// Complete your string stack implementation in this file.
struct _Stack {
    char** elements;
    int top;
    int capacity;
};

stack_response create() {
    stack s = malloc(sizeof(struct _Stack));
    if (s == NULL) {
        return (stack_response){out_of_memory, NULL};
    }
    s->top = 0;
    s->capacity = INITIAL_CAPACITY;
    s->elements = malloc(INITIAL_CAPACITY * sizeof(char*));
    if (s->elements == NULL) {
        free(s);
        return (stack_response){out_of_memory, NULL};
    }
    return (stack_response){success, s};
}

int size(const stack s) {
    return s->top;
}

bool is_empty(const stack s) {
    return s->top == 0;
}

bool is_full(const stack s) {
    return s->top == MAX_CAPACITY;
}

response_code push(stack s, char* item) {
    
    if (is_full(s)) {
        return stack_full;
    }

    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }

    if (s->top == s->capacity) {
        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY) {
            new_capacity = MAX_CAPACITY;
        }

        char** new_elements = realloc(s->elements, new_capacity * sizeof(char*));
        if (new_elements == NULL) {
            return out_of_memory;
        }
        s->elements = new_elements;
        s->capacity = new_capacity;
    }

    s->elements[s->top++] = strdup(item);
    return success;
}

string_response pop(stack s) {
    if (is_empty(s)) {
        return (string_response){stack_empty, NULL};
    }
    char* popped = s-> elements[--s->top];
    int new_capacity = s->capacity / 2;
    if (new_capacity < 1) {
        new_capacity = 1;
    }
    char** new_elements = realloc(s->elements, new_capacity * sizeof(char*));
    if (new_elements == NULL) {
        return (string_response){out_of_memory, NULL};
    }
    s->elements = new_elements;
    s->capacity = new_capacity;

    return (string_response){success, popped};
}


void destroy(stack* s) {
    if (s == NULL || *s == NULL) {
        return;
    }
    for (int i = 0; i < (*s)->top; i++) {
        free((*s)->elements[i]);
    }
    free((*s)->elements); 
    free(*s);
    *s = NULL;
}
