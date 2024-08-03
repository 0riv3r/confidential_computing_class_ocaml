(* Rock Papaer Scissors *)

(*
  @author: Ofer Rivlin
  mail: ofer.rivlin@intel.com   
*) 


Random.self_init ()
exception Invalid_argument of string

type tool = R' | P' | S'
type outcome = Win | Lose | Tie

let tool_to_string = function
  | R' -> "Rock"
  | P' -> "Paper"
  | S' -> "Scissors"

let tool_of_string = function
  | "r" -> R'
  | "p" -> P'
  | "s" -> S'
  | x   -> raise (Invalid_argument (String.concat " "["You can't use"; x; "!"]))


let duel opponent = function
 | R' -> if opponent = S' then Win else Lose
 | P' -> if opponent = R' then Win else Lose
 | S' -> if opponent = P' then Win else Lose

let draw_random_tool rand =
  match (rand mod 3) with
  (* match (Random.State.bits (Random.get_state ()) mod 3) with *)
  (* match (Random.int 3) with *)
  | 0 -> R'
  | 1 -> P'
  | 2 -> S'
  | r -> raise (Invalid_argument (String.concat " "["random"; string_of_int r; "!"]))

let choose_winning_tool = function
| R' -> P'
| P' -> S'
| S' -> R'

let play mt ot =
  if mt = ot then Tie else (duel ot mt)

let result mt ot =
  match (play mt ot) with
  | Win -> "Alice wins"
  | Lose -> "Alice loses"
  | _ -> "tie"
