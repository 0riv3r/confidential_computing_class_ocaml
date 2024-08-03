open Rps_lib.Rps

(*
  @author: Ofer Rivlin
  mail: ofer.rivlin@intel.com   
*) 

let () =
  Printf.printf "\nWhat's Bob's tool? (r/p/s)";
  let sot = read_line () in
  let ot = tool_of_string sot in
  let rand = Random.State.bits (Random.get_state ()) in
  let mt = draw_random_tool rand in
  Printf.printf "\nYour tool: %s\nAlice's tool: %s\nDual outcome: %s\n\n%!" 
  (tool_to_string ot)
  (tool_to_string mt)
  (result mt ot);