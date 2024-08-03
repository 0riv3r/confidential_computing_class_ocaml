(** he_rsa
    Multiplicative Homomorphic Encryption using the RSA cryptosystemm.
    Lib file.
      @author Ofer Rivlin
      @email  ofer.rivlin@intel.com
*)

open Z (* Zarith *)


(** generate RSA private and public keys 
    t -> t -> (t * t) * (t * t)
*)
let generate_keys p q =
  
  (* Z.mul: t -> t -> t 
  Multiplication. *)
  let n = mul p q in

  (* Z.pred: t -> t
  Returns its argument minus one. *)
  let totient = (pred p) * (pred q) in

  (* Normally, e is selected such that it's relatively prime to the totient *)
  (* let e = of_int 7 in *)
  let e = (pred totient) in

  (* Z.invert:  t -> t -> t
  [invert base mod] returns the inverse of [base] modulo [mod]. *)
  let d = invert e totient in

  (* 
    e is public key.
    d is private key.
  *)
  n, e, d


(** encrypt using the RSA public key *)
let encrypt msg (n, e) = powm msg e n

(** decrypt using the RSA private key *)
let decrypt enc (n, d) = powm enc d n
