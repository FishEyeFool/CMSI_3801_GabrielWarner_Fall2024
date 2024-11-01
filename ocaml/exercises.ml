exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

(** 
 * @brief Applies a consumer function to the first element 
 *        in a list that satisfies a given predicate.
 *
 *  The 'first_then_apply' function takes a list of elements, 
 *  a predicate function, and a consumer function. It finds the 
 *  first element in the list that satisfies the predicate 
 *  and applies the consumer function to it. If no such element is found, it returns 'None'.
 *
 *  @param list: 'a list - A list of elements to be processed.
 *  @param predicate: 'a -> bool - A function that takes an element and returns a 'bool' 
                       indicating whether the element satisfies the condition.
 *  @param consumer: 'a -> 'b option - A function that takes an element and returns an optional result.
 *  @return 'b option - 'Some' the result of applying the consumer function 
             to the first element that satisfies the predicate,
 *           or 'None' if no such element is found.
 *)
let first_then_apply 
  (list: 'a list) 
  (predicate: 'a -> bool) 
  (consumer: 'a -> 'b option) : 'b option = 
  match List.find_opt predicate list with
  | Some foundItem -> consumer foundItem
  | None -> None
;;

(** 
 * @brief Generates an infinite sequence of powers of a given base.
 *
 * The 'powers_generator' function takes an integral base and 
   returns an infinite sequence of its powers, starting from 1.
 * It uses a recursive helper function to generate the sequence.
 * 
 * @param base: int - The base number for generating powers.
 * @return (unit -> int Seq.node) - An infinite sequence of powers of the given base.
 *)
let powers_generator base = 
  let rec generate_from power () = 
    Seq.Cons (power, generate_from (power * base))
  in
  generate_from 1
;;

(** 
 * @brief Counts the number of meaningful lines in a file.
 *
 * The 'meaningful_line_count' function reads a file and 
   counts the number of meaningful lines it contains.
 * A meaningful line is defined as a line that is not empty and does not start with a '#' character.
 *
 * @param file_name: string - The name of the file to be processed.
 * @return int - The number of meaningful lines in the file.
 *
 *   meaningful_line_count "example.txt"
 *   -- Returns: 2
 *)
let meaningful_line_count file_name =
  let input_channel = open_in file_name in
  let finally () = close_in input_channel in
  let work () =
    let rec loop count =
      try
        let line = input_line input_channel in
        let trimmed_line = String.trim line in
        if trimmed_line = "" || trimmed_line.[0] = '#' then
          loop count
        else
          loop (count + 1)
      with End_of_file -> count
    in
    loop 0
  in
  Fun.protect ~finally work
;;

(**
 * @brief Defines geometric shapes and calculates their volume and surface area.
 *
 * This module provides a data type for geometric shapes (Sphere and Box) and 
   functions to calculate their volume and surface area.
 * It also includes a function to convert a shape to a string representation.
 *
 * Data Types:
 *   - shape: Represents a geometric shape, which can be either a Sphere or a Box.
 *
 * Functions:
 *   - volume: Calculates the volume of a given shape.
 *       @param shape: The shape for which to calculate the volume.
 *       @return float: The volume of the shape.
 *
 *   - surface_area: Calculates the surface area of a given shape.
 *       @param shape: The shape for which to calculate the surface area.
 *       @return float: The surface area of the shape.
 *
 *   - shape_to_string: Converts a shape to its string representation.
 *       @param shape: The shape to be converted to a string.
 *       @return string: The string representation of the shape.
 *)
type shape = 
  | Sphere of float
  | Box of float * float * float

let volume shape =
  match shape with
  | Sphere radius -> (4.0 /. 3.0) *. Float.pi *. radius ** 3.0
  | Box (width, length, depth) -> width *. length *. depth
;;

let surface_area shape =
  match shape with 
  | Sphere radius -> 4.0 *. Float.pi *. radius ** 2.0
  | Box (width, length, depth) -> 
      2.0 *. (width *. length +. length *. depth +. depth *. width)
;;

let shape_to_string shape =
  match shape with 
  | Sphere radius -> Printf.sprintf "Sphere with radius %.0f" radius
  | Box (width, length, depth) -> 
      Printf.sprintf "Box with width %.0f, length %.0f, and depth %.0f" width length depth
;;

(** 
 * @brief Defines a binary search tree (BST) and provides basic operations on it.
 *
 * The binary search tree allows for efficient insertion, deletion, 
 * and lookup of elements. For any given node, all values in the 
 * left subtree are less than the node's value, and all values in 
 * the right subtree are greater.
 *
 * Type:
 *   - 'a binary_search_tree: A binary search tree that can hold values 
 *     of any type 'a. It can either be empty or consist of a node 
 *     containing a value and two subtrees.
 *
 * Variants:
 *   - Empty: Represents an empty binary search tree.
 *   - Node of 'a binary_search_tree * 'a * 'a binary_search_tree: 
 *     Represents a node with a value of type 'a', a left subtree, 
 *     and a right subtree.
 *
 * Functions:
 *
 *   - size: 
 *     Counts the number of nodes in the binary search tree.
 *     @param tree: 'a binary_search_tree - The tree to be counted.
 *     @return int - The total number of nodes in the tree.
 *
 *   - contains: 
 *     Checks if a given value exists in the binary search tree.
 *     @param value: 'a - The value to search for in the tree.
 *     @param tree: 'a binary_search_tree - The tree to search.
 *     @return bool - True if the value exists, false otherwise.
 *
 *   - inorder: 
 *     Returns a list of the elements in the binary search tree in sorted order.
 *     @param tree: 'a binary_search_tree - The tree to traverse.
 *     @return 'a list - A list of the elements in sorted order.
 *
 *   - insert: 
 *     Inserts a new value into the binary search tree.
 *     @param value: 'a - The value to be inserted.
 *     @param tree: 'a binary_search_tree - The tree to insert the value into.
 *     @return 'a binary_search_tree - The updated tree with the new value.
 *
 *   Example:
 *   - insert 5 Empty
 *   -- Returns: Node (Empty, 5, Empty)
 *)

type 'a binary_search_tree =
  | Empty
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

let rec size tree =
  match tree with
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right
;;

let rec contains value tree =
  match tree with
  | Empty -> false
  | Node (left, node_value, right) -> 
    if value = node_value then
      true
    else if value < node_value then
      contains value left
    else
      contains value right
;;

let rec inorder tree =
  match tree with
  | Empty -> []
  | Node (left, node_value, right) -> 
    inorder left @ [node_value] @ inorder right
;;

let rec insert value tree =
  match tree with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, node_value, right) -> 
    if value < node_value then
      Node (insert value left, node_value, right)
    else if value > node_value then
      Node (left, node_value, insert value right)
    else
      tree
;;