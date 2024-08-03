(** he_paillier_main
    Additive Homomorphic Encryption using the Paillier cryptosystem.
    Main file.
      @author Ofer Rivlin
      @email  ofer.rivlin@intel.com
*)

open He_libs


(* Data *)

(* bits length of the encryption keys *)
let kbits = Z.of_int 4096    (* 32/64/128/256/512/1024/2048/3072/4096 *)

(* Integers for encrypted addition *)
let m1 = Z.of_int 72 
let m2 = Z.of_int 28


(* main *)

let () =
    (* (* print Min, Max *)
  let minmax = min_max_for_prime kbits in
    Printf.printf "Min = %s\nMax = %s\n%!" (Z.to_string (fst minmax)) (Z.to_string (snd minmax) ); *)

  (* print the primes p and q *)
  let minmax = He_bigints.min_max_for_prime kbits in
  let (p,q) = He_bigints.random_primes (Z.to_string(fst minmax)) (Z.to_string(snd minmax)) in
    Printf.printf "\nPrime p = %s\n%!\nPrime q = %s\n%!" (Z.to_string p) (Z.to_string q);

  (* print the public key (comprise of n and g) *)
  let public_key, private_key = He_paillier.generate_keys p q in
    Printf.printf "\nKeys generated:\nn = %s\n\ng = %s\n%!" (Z.to_string (fst public_key)) (Z.to_string (snd public_key) );
    (* you can check the bits length of the key at: https://planetcalc.com/8985/*)

  (* print the ciphertext of the encrypted first value *)
  let c1 = He_paillier.encrypt m1 public_key in
    Printf.printf "\nPlaintext m1: %s\nEncrypted m1: %s\n%!" (Z.to_string m1)(Z.to_string c1);

  (* print the ciphertext of the encrypted second value *)
  let c2 = He_paillier.encrypt m2 public_key in
    Printf.printf "\nPlaintext m2: %s\nEncrypted m2: %s\n%!" (Z.to_string m2)(Z.to_string c2);

  (* print the ciphertext of the encrypted sum of the first and second values *)
  let c_sum = Z.mul c1 c2 |> fun x -> Z.rem x (Z.mul (fst public_key) (fst public_key)) in
    Printf.printf "\nEncrypted Sum: %s\n%!" (Z.to_string c_sum);

  (* print the cleartext of the decrypted sum of the first and second values *)
  let decrypted_sum = He_paillier.decrypt c_sum public_key private_key in
    Printf.printf "\nDecrypted Sum: %s\n%!" (Z.to_string decrypted_sum);
