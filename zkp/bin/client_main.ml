open Rps_lib
open Nocoiner

(*
  @author: Ofer Rivlin
  mail: ofer.rivlin@intel.com   
*) 


let tool = "r";; (* Set Bob's tool here: r/p/s in *COMMITMENT* process *)
let (commitment, opening) = commit tool;;

let () =

  (* ========================================================= *)
  (* vvv      *REGULAR* client/server process     vvv *)
  (* This seection below should be uncomment when REGULAR client/server process *)
  (* and commented-out when in commitment process *)

  (* *)

  let body = Lwt_main.run (Client.chosen_tool "r") in (* Set Bob's tool here: r/p/s in *REGULAR* process *)
  Printf.printf "\nChosen Tool Response:\n%s\n\n" body;

  (* *)

  (* ^^^    *REGULAR* client/server process above     ^^^ *)


  (* ========================================================= *)
  (* ========================================================= *)
  (* ========================================================= *)
  (* ========================================================= *)


  (* vvv    *COMMITMENT* client/server process below vvv     *)

  (* This seection below should be uncomment when COMMITMENT client/server process *)
  (* and commented-out when in regular process *)

  (* 

  Printf.printf "\n=========================================================\n";

  let body = Lwt_main.run (Client.commit commitment) in
  Printf.printf "\nCommit Response: %s\n\n" body;

  Printf.printf "=========================================================\n";

  let body = Lwt_main.run (Client.opening opening) in
  Printf.printf "\nOpening Response: %s\n\n" body;

  Printf.printf "=========================================================\n\n"; 
  
    *)


  (* ^^^    *COMMITMENT* client/server process above     ^^^ *)

  (* ========================================================= *)