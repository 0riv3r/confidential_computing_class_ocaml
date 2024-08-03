(** he_rsa_main
    Multiplicative Homomorphic Encryption using the RSA cryptosystemm.
    Main file.
      @author Ofer Rivlin
      @email  ofer.rivlin@intel.com
*)

open He_libs
open Z


(* Data *)

(* bits length of the encryption keys *)
let kbits = Z.of_int 4096    (* 32/64/128/256/512/1024/2048/3072/4096 *)

(* Integers for encrypted addition *)
let m1 = Z.of_int 25 
let m2 = Z.of_int 4

(* let p = of_int 38993 (11   Normally, we would use a large prime number here
let q = of_int 51407  (3 Normally, we would use a large prime number here *)

(* main *)

let () = 

  (* generate the primes p and q *)
  let minmax = He_bigints.min_max_for_prime kbits in
  let (p,q) = He_bigints.random_primes (Z.to_string(fst minmax)) (Z.to_string(snd minmax)) in
  (* print the primes p and q *)
  Printf.printf "\nPrime p = %s\n%!\nPrime q = %s\n%!" (Z.to_string p) (Z.to_string q);

   (* generate RSA keys *)
  let n, e, d = He_rsa.generate_keys p q in
  let public_key = (n, e) in
  let private_key = (n, d) in
  (* print the public key (comprise of n and e) *)
  Printf.printf "\nKeys generated:\nn = %s\n\ne = %s\n%!" (Z.to_string (fst public_key)) (Z.to_string (snd public_key) );
  (* you can check the bits length of the key at: https://planetcalc.com/8985/*)


  (* print the ciphertext of the encrypted first value *)
  let c1 = He_rsa.encrypt m1 public_key in
    Printf.printf "\nPlaintext m1: %s\nEncrypted m1: %s\n%!" (Z.to_string m1)(Z.to_string c1);

  (* print the ciphertext of the encrypted second value *)
  let c2 = He_rsa.encrypt m2 public_key in
    Printf.printf "\nPlaintext m2: %s\nEncrypted m2: %s\n%!" (Z.to_string m2)(Z.to_string c2);

  (* print the ciphertext of the encrypted product of the two encrypted values *)
  (* Homomorphic property: (enc1 * enc2) mod n = encrypt(m1 * m2) mod n *)
  let c_prod = (Z.mul c1 c2) mod n in
    Printf.printf "\nHomomorphic encrypted Product of m1 and m2: %s\n%!" (Z.to_string c_prod);

  (* Decrypt the result *)
  (* print the cleartext of the decrypted sum of the first and second values *)
  let decrypted_prod = He_rsa.decrypt c_prod private_key in
    Printf.printf "\nDecrypted Product of m1 and m2: %s\n%!" (Z.to_string decrypted_prod);
