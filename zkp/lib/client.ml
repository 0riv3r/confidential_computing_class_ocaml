open Lwt
open Cohttp
open Cohttp_lwt_unix
(* open Nocoiner *)

(*
  @author: Ofer Rivlin
  mail: ofer.rivlin@intel.com   
*) 


(*
The symbol >>= is defined by Lwt, not by OCaml itself. 
It's an infix operator equivalent to Lwt.bind.
val bind : 'a t -> ('a -> 'b t) -> 'b t
https://ocsigen.org/lwt/5.5.0/api/Lwt#VALbind
https://ocsigen.org/lwt/5.5.0/api/Lwt.Infix

The symbol >|= is defined by Lwt, not by OCaml itself. 
It's an infix operator equivalent to Lwt.map.
val map : ('a -> 'b) -> 'a t -> 'b t
https://ocsigen.org/lwt/5.5.0/api/Lwt#VALmap
https://ocsigen.org/lwt/5.5.0/api/Lwt.Infix

*)

let uri_base = "http://localhost:8080/";;
let uri_commit = "commit/";;
let uri_open = "opening/";;
let uri_echo = "echo/";;
let uri_tool = "tool/";;

let ok_response_action body =
  body |> Cohttp_lwt.Body.to_string >|=
    fun body -> "\n" ^ body

let other_response_action status body =
  body |> Cohttp_lwt.Body.to_string >|= 
    fun body -> "\n" ^ string_of_int status ^ "\n" ^ body

let commit commitment =
  let uri = uri_base ^ uri_commit in
  Client.post
    ~body:(Cohttp_lwt.Body.of_string commitment)
    (Uri.of_string uri)
    >>= fun (response, body) ->
    match response with
    | { Cohttp.Response.status = `OK; _ } -> ok_response_action body
    | { Cohttp.Response.status; _ } -> other_response_action (
        status |> Code.code_of_status) body

let opening opening_key =
  let uri = uri_base ^ uri_open in
  Client.post
    ~body:(Cohttp_lwt.Body.of_string opening_key)
    (Uri.of_string uri)
    >>= fun (response, body) ->
    match response with
    | { Cohttp.Response.status = `OK; _ } -> ok_response_action body
    | { Cohttp.Response.status; _ } -> other_response_action (
        status |> Code.code_of_status) body

let echo =
  let uri = uri_base ^ uri_echo in
  Client.get
    (Uri.of_string uri)
  >>= fun (response, body) ->
  match response with
  | { Cohttp.Response.status = `OK; _ } -> ok_response_action body
  | { Cohttp.Response.status; _ } -> other_response_action (
      status |> Code.code_of_status) body

let chosen_tool tool =
  let uri = uri_base ^ uri_tool ^ tool in
  Client.get
    (Uri.of_string uri)
  >>= fun (response, body) ->
  match response with
  | { Cohttp.Response.status = `OK; _ } -> ok_response_action body
  | { Cohttp.Response.status; _ } -> other_response_action (
      status |> Code.code_of_status) body
      

(* 
  let secret = "I have nothing to hide."
  let (c, o) = Nocoiner.commit secret

  assert (secret = Nocoiner.reveal ~commitment:c ~opening:o)   
*)
