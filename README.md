# CMSI 3801 Homework

# Homework 1:
Students: Gabriel Warner <br>
Description: Applying concepts such as declarations, expressions, statements, static scope, constants, variables, types, functions, modules, assignments, function calls, higher-order functions, closures, polymorphism, sequencing, selection, iteration, recursion, exceptions, generators, coroutines, and async-await, using Python, JavaScript, and Lua. These concepts were applied by implementing a variety of scripts, including a Quaternions class and a power generator.

# Homework 2:
Students: Gabriel Warner <br>
Description: Applying concepts such as abstraction, objects, encapsulation, information hiding, inheritance, dynamic polymorphism, streams, abstract types, records, and sealed classes, using Java, Kotlin, and Swift.

# Homework 3:
Students: Gabriel Warner <br>
Description: Applying concepts such as type inference, type variables, algebraic data types, functional programming, loop-free programming, point-free programming, typeclasses, and monadic file processing, using TypeScript, OCaml, and Haskell.

# Homework 4:
Students: Gabriel Warner <br>
Description: Demonstrating the ability to write and test functions and user-defined types in C, C++, and Rust and employing manual memory management techniques in the development of a dynamic abstract data type in a systems programming language.

# Homework 5:
Students: Gabriel Warner <br>
Description: Demonstrating the ability to write concurrent code in Go, an understanding of basic concurrency principles, and a cursory understanding of the difference between shared-memory concurrency and message-passing concurrency.

## Testing Instructions

### Lua

```
lua exercises_test.lua
```

### Python

```
python3 exercises_test.py
```

### JavaScript

```
npm test
```

### Java

```
javac *.java && java ExercisesTest
```

### Kotlin

```
kotlinc *.kt -include-runtime -d test.jar && java -jar test.jar
```

### Swift

```
swiftc -o main exercises.swift main.swift && ./main
```

### TypeScript

```
npm test
```

### OCaml

```
ocamlc exercises.ml exercises_test.ml && ./a.out
```

### Haskell

```
ghc ExercisesTest.hs && ./ExercisesTest
```

### C

```
gcc string_stack.c string_stack_test.c && ./a.out
```

### C++

```
g++ -std=c++20 stack_test.cpp && ./a.out
```

### Rust

```
cargo test
```

### Go

```
go run restaurant.go
```
