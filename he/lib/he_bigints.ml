(** Shared functions for handling big integers in our 
    confidential computing class HE projects.
      @author Ofer Rivlin
      @email  ofer.rivlin@intel.com
*)

open Z        (* Zarith *)
include Py    (* pyml *)

let () = Py.initialize ()


(** min and max integers of a given bits length *)
let min_max_for_prime kbits = 
  let pbits = div kbits (Z.of_int 2) in
  ( ((Z.pow (Z.of_int 2) (Z.to_int pbits)) / (Z.of_int 2) ),
    ((Z.pow (Z.of_int 2) (Z.to_int pbits)) - (Z.of_int 1) ) )


(** two random prime numbers in the range [smin, smax). 
    enables big numbers.
    input numbers as strings.
    output as Z.t.
*)
let random_primes smin smax =
  let pymin = Py.Long.of_string smin in
  let pymax = Py.Long.of_string smax in
  let sym = Py.import "sympy" in
  let open Pyops in (* required for the use of .& *)
  (* in python: p= sym.randprime(min_int, max_int+1) *)
  (* Py.Module.get_function sym "randprime" [| imin; imax |] *)
  ( Z.of_string (Py.Long.to_string (sym.&("randprime") [| pymin; pymax |])),
    Z.of_string (Py.Long.to_string (sym.&("randprime") [| pymin; pymax |])))


(**  a rundom big integer in the range [lower, upper) *)
let random_bigint_in_range ~lower ~upper =
  
  (* Z.sub: t -> t -> t
      Subtraction. *)
  let diff = sub upper lower in
   
  (* Z.add: t -> t -> t
      Addition. *)
  (* |> 
      pipe *)
  (* rem: t -> t -> t
      Integer remainder. *)
  (* The Random functions generate seed and manipulate a PRNG *)
  add lower (Random.State.bits (Random.get_state ()) |> of_int |> rem diff)

