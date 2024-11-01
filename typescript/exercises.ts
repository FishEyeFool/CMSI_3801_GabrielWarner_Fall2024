import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

/**
 * Applies a consumer function to the first item in an array that matches a given predicate.
 *
 * @template T - The type of items in the array.
 * @template U - The return type of the consumer function.
 * @param {T[]} items - The array of items to search through.
 * @param {(item: T) => boolean} predicate - A function that returns true for the desired item.
 * @param {(item: T) => U} consumer - A function to apply to the found item.
 * @returns {U | undefined} - The result of the consumer function if an item is found, otherwise undefined.
 */
export function firstThenApply<T, U>(
  items: T[], 
  predicate: (item: T) => boolean, 
  consumer: (item: T) => U
): U | undefined {
  const foundItem = items.find(item => predicate(item))
  return foundItem ? consumer(foundItem) : undefined;
}

/**
 * Generates an infinite sequence of powers of a given base.
 *
 * @param {bigint} base - The base number for generating powers.
 * @yields {bigint} - The next power of the base in the sequence.
 */
export function* powersGenerator(base: bigint): Generator<bigint> {
  for (let power = 1n; ; power *= base) {
    yield power;
  }
}

/**
 * Counts the number of meaningful lines in a file.
 * A meaningful line is defined as a non-empty line that does not start with a '#' character.
 *
 * @param {string} fileName - The name of the file to be read.
 * @returns {Promise<number>} - A promise that resolves to the number of meaningful lines in the file.
 */
export async function meaningfulLineCount(fileName: string): Promise<number> {
  const fileHandle = await open(fileName, 'r');
  let count = 0;

  try {
    for await (const line of fileHandle.readLines()) {
      if (line.trim() !== '' && !line.trim().startsWith('#')) {
        count++;
      }
    }
  } finally {
      await fileHandle.close();
  }
  return count;
}

/**
 * Represents a sphere with a specific radius.
 */
interface Sphere {
  readonly kind: "Sphere";
  readonly radius: number;
}

/**
 * Represents a box with specific dimensions.
 */
interface Box {
  readonly kind: "Box";
  readonly width: number;
  readonly length: number;
  readonly depth: number;
}

/**
 * A union type representing either a Sphere or a Box.
 */
export type Shape = Sphere | Box;

/**
 * Calculates the surface area of a given shape.
 *
 * @param {Shape} shape - The shape for which to calculate the surface area.
 * @returns {number} - The surface area of the shape.
 */
export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return 4 * Math.PI * Math.pow(shape.radius, 2);
    case "Box":
      return 2 * (shape.width * shape.length + shape.length * shape.depth + shape.depth * shape.width);
  }
}

/**
 * Calculates the volume of a given shape.
 *
 * @param {Shape} shape - The shape for which to calculate the volume.
 * @returns {number} - The volume of the shape.
 */
export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * Math.pow(shape.radius, 3);
    case "Box":
      return shape.width * shape.length * shape.depth;
  }
}

/**
 * Converts a shape to a string representation.
 *
 * @param {Shape} shape - The shape to convert to a string.
 * @returns {string} - A string representation of the shape.
 */
export function shapeToString(shape: Shape): string {
  switch (shape.kind) {
    case "Sphere":
      return `Sphere with radius ${shape.radius}`;
    case "Box":
      return `Box with width ${shape.width}, height ${shape.length}, and depth ${shape.depth}`;
  }
}

/**
 * Compares two shapes for equality.
 *
 * @param {Shape} shape1 - The first shape to compare.
 * @param {Shape} shape2 - The second shape to compare.
 * @returns {boolean} - True if the shapes are equal, false otherwise.
 */
export function equals(shape1: Shape, shape2: Shape): boolean {
  if (shape1.kind !== shape2.kind) {
    return false;
  }
  if (shape1.kind === "Sphere" && shape2.kind === "Sphere") {
    return shape1.radius === shape2.radius;
  }
  if (shape1.kind === "Box" && shape2.kind === "Box") {
    return shape1.width === shape2.width &&
           shape1.length === shape2.length &&
           shape1.depth === shape2.depth;
  }
  return false;
}

/**
 * Interface representing a generic Binary Search Tree (BST).
 */
export interface BinarySearchTree<T> {
  /**
   * Returns the number of elements in the BST.
   * @returns {number} The size of the BST.
   */
  size(): number;

  /**
   * Inserts a value into the BST and returns the updated BST.
   * @param {T} value - The value to insert.
   * @returns {BinarySearchTree<T>} The updated BST.
   */
  insert(value: T): BinarySearchTree<T>;

  /**
   * Checks if a value is present in the BST.
   * @param {T} value - The value to check.
   * @returns {boolean} True if the value is present, false otherwise.
   */
  contains(value: T): boolean;

  /**
   * Returns an iterable for in-order traversal of the BST.
   * @returns {Iterable<T>} An iterable for in-order traversal.
   */
  inorder(): Iterable<T>;

  /**
   * Returns a string representation of the BST.
   * @returns {string} The string representation of the BST.
   */
  toString(): string;
}

/**
 * Class representing an empty node in a BST.
 */
export class Empty<T> implements BinarySearchTree<T> {
  /**
   * Returns the number of elements in the BST.
   * @returns {number} The size of the BST, which is 0 for an empty node.
   */
  size(): number {
    return 0;
  }

  /**
   * Inserts a value into the BST and returns a new node containing the value.
   * @param {T} value - The value to insert.
   * @returns {BinarySearchTree<T>} A new node containing the value.
   */
  insert(value: T): BinarySearchTree<T> {
    return new Node(value, new Empty(), new Empty());
  }

  /**
   * Checks if a value is present in the BST.
   * @param {T} value - The value to check.
   * @returns {boolean} False, as an empty node cannot contain any value.
   */
  contains(value: T): boolean {
    return false;
  }

  /**
   * Returns an iterable for in-order traversal of the BST.
   * @returns {Iterable<T>} An empty iterable.
   */
  inorder(): Iterable<T> {
    return this._inorder();
  }

  /**
   * Private generator method for in-order traversal.
   * @returns {Iterable<T>} An empty iterable.
   */
  private *_inorder(): Iterable<T> {
    return;
  }

  /**
   * Returns a string representation of the empty node.
   * @returns {string} The string representation of the empty node, which is "()".
   */
  toString(): string {
    return "()";
  }
}

/**
 * Class representing a node in a BST.
 */
class Node<T> implements BinarySearchTree<T> {
  private value: T;
  private left: BinarySearchTree<T>;
  private right: BinarySearchTree<T>;

  /**
   * Creates a new node.
   * @param {T} value - The value of the node.
   * @param {BinarySearchTree<T>} left - The left subtree.
   * @param {BinarySearchTree<T>} right - The right subtree.
   */
  constructor(value: T, left: BinarySearchTree<T>, right: BinarySearchTree<T>) {
    this.value = value;
    this.left = left;
    this.right = right;
  }

  /**
   * Returns the number of elements in the BST.
   * @returns {number} The size of the BST.
   */
  size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  /**
   * Inserts a value into the BST and returns the updated BST.
   * @param {T} value - The value to insert.
   * @returns {BinarySearchTree<T>} The updated BST.
   */
  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new Node(this.value, this.left.insert(value), this.right);
    } else if (value > this.value) {
      return new Node(this.value, this.left, this.right.insert(value));
    }
    return this;
  }

  /**
   * Checks if a value is present in the BST.
   * @param {T} value - The value to check.
   * @returns {boolean} True if the value is present, false otherwise.
   */
  contains(value: T): boolean {
    if (value === this.value) {
      return true;
    } else if (value < this.value) {
      return this.left.contains(value);
    } else {
      return this.right.contains(value);
    }
  }

  /**
   * Returns an iterable for in-order traversal of the BST.
   * @returns {Iterable<T>} An iterable for in-order traversal.
   */
  inorder(): Iterable<T> {
    return this._inorder();
  }

  /**
   * Private generator method for in-order traversal.
   * @returns {Iterable<T>} An iterable for in-order traversal.
   */
  private *_inorder(): Iterable<T> {
    yield* this.left.inorder();
    yield this.value;
    yield* this.right.inorder();
  }

  /**
   * Returns a string representation of the node.
   * @returns {string} The string representation of the node.
   */
  toString(): string {
    const leftStr = this.left instanceof Empty ? "" : this.left.toString();
    const rightStr = this.right instanceof Empty ? "" : this.right.toString();
    return `(${leftStr}${this.value}${rightStr})`;
  }
}