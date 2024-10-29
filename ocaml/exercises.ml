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

(* Write your first then apply function here *)
let first_then_apply 
  (list: 'a list) 
  (predicate: 'a -> bool) 
  (consumer: 'a -> 'b option) : 'b option = 
  match List.find_opt predicate list with
  | Some foundItem -> consumer foundItem
  | None -> None
;;

(* Write your powers generator here *)
let powers_generator base = 
  let rec generate_from power () = 
    Seq.Cons (power, generate_from (power * base))
  in
  generate_from 1
;;

(* Write your line count function here *)
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

(* Write your shape type and associated functions here *)
type shape = 
  | Sphere of float
  | Box of float * float * float

let volume shape =
  match shape with
  | Sphere radius -> (4.0 /. 3.0) *. Float.pi *. radius ** 3.0
  | Box (width, length, depth) -> width *. length *. depth

let surface_area shape =
  match shape with 
  | Sphere radius -> 4.0 *. Float.pi *. radius ** 2.0
  | Box (width, length, depth) -> 
      2.0 *. (width *. length +. length *. depth +. depth *. width)

let shape_to_string shape =
  match shape with 
  | Sphere radius -> Printf.sprintf "Sphere with radius %.0f" radius
  | Box (width, length, depth) -> 
      Printf.sprintf "Box with width %.0f, length %.0f, and depth %.0f" width length depth

(* Write your binary search tree implementation here *)
