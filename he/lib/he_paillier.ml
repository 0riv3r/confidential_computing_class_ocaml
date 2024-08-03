(** he_paillier
    Additive Homomorphic Encryption using the Paillier cryptosystem.
    Lib file.
      @author Ofer Rivlin
      @email  ofer.rivlin@intel.com
*)

open Z (* Zarith *)


(** generate Paillier private and public keys 
    t -> t -> (t * t) * (t * t)
*)
let generate_keys p q =
  
  (* Z.mul: t -> t -> t 
  Multiplication. *)
  let n = mul p q in
 
  (* Z.pred: t -> t
  Returns its argument minus one. *)
  let lambda = lcm (pred p) (pred q) in
 
  (* Z.succ: t -> t
  Returns its argument plus one. *)
  let g = succ n in
  
  (* Z.invert:  t -> t -> t
  [invert base mod] returns the inverse of [base] modulo [mod]. *)
  let mu = invert lambda n in

  (* 
    the value of two pairs.
    First pair comprise the public key.
    Second pair comprise the private key.
  *)
  (n, g), (lambda, mu)
  
  
(** encrypt using the Paillier public key *)
let encrypt m (n, g) =
  let r = He_bigints.random_bigint_in_range ~lower:one ~upper:(pred n) in

  (* Z.powm: t -> t -> t -> t
    [powm base exp mod] computes [base]^[exp] modulo [mod]. *)
  (* Z.mul: t -> t -> t 
    Multiplication. *)
  let gm = powm g m (mul n n) in
  let rn = powm r n (mul n n) in

  (* Z.rem: t -> t -> t
    Integer remainder. *)
  rem (mul gm rn) (mul n n)


(** decrypt using the Paillier private key *)
let decrypt c (n, g) (lambda, mu) =

  (* Z.powm: t -> t -> t -> t
    [powm base exp mod] computes [base]^[exp] modulo [mod]. *)
  let cl = powm c lambda (mul n n) in

  (* div: t -> t -> t
    Integer division. *)
  (* Z.sub: t -> t -> t
      Subtraction. *)
  (* one: t
    The number 1. *)
  let l x = div (sub x one) n in
  rem (mul (l cl) mu) n