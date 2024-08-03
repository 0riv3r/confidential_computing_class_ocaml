open Rps

(*
  @author: Ofer Rivlin
  mail: ofer.rivlin@intel.com   
*) 


module S = Tiny_httpd
(* 
   https://github.com/c-cube/tiny_httpd 
   https://c-cube.github.io/tiny_httpd/
*)
let length_of_rands_list = 100;; (** a list of 100 random integers *)
let counter = ref 0;; (* counter is mutable *)
let commitment = ref "";;
let opening_key = ref "";;
let my_tool  = ref R';;

(* 
  Generate list of random numbers.
  I do this since generating a new random integer at each call, 
  as it is implemented in the rps file, yields here the same
  number at each call.  (could be a cache issue on the server?)
  Here I call a counter which I increment at each call to get the next random number
  in the list.

  https://stackoverflow.com/questions/54188557/random-number-generation-in-ocaml 
  https://stackoverflow.com/questions/22565045/ocaml-variable-counting
*)
let rec gen_rands ?(acc=[]) = function
  | 0 -> acc
  | size ->
      let n = Random.int 1000000 in
      gen_rands ~acc:(n :: acc) (size - 1)

let rands = gen_rands(length_of_rands_list);;

let http_server =
  let server = S.create () in

  (* chosen tool request *)
  S.add_route_handler ~meth:`GET server
    S.Route.(exact "tool" @/ string @/ return)
    (fun tool _req ->
      let ot = tool_of_string (String.sub tool 0 1) in
      let mt = choose_winning_tool ot in
      S.Response.make_string (Ok 
      (String.concat " "[
        "Bob's tool:";(tool_to_string ot);
        "\nAlice's tool:";(tool_to_string mt);
        "\nDual outcome:";(result mt ot)]))
    );

  (* commit request *)
  S.add_route_handler server
    S.Route.(exact "commit" @/ return)
    (fun req -> 
      (* 
        get the counter's value.
        Increment the counter as long as it is smaller than the length of the list.
        Otherwise, reset it.
      *)
      if !counter < ((List.length rands) -1) then
        incr counter
      else
        counter := 0;
      commitment := req.body;
      my_tool := draw_random_tool (List.nth rands !counter);
      S.Response.make_string (Ok 
        (String.concat " "[
        (* "Next: ";(string_of_int !counter); *) (* to printout the counter *)
        (* "Bob's tool:";(tool_to_string ot); *)
        "\nBob's Commitment:\n\n";(!commitment);
        "\n\nAlice's Tool:";(tool_to_string !my_tool)]))
    );

  (* open request *)
  S.add_route_handler server
    S.Route.(exact "opening" @/ return)
    (fun req -> 
      opening_key := req.body;
      (* let mt = draw_random_tool (List.nth rands !counter) in *)
      let ot = Nocoiner.reveal 
                ~commitment:!commitment 
                ~opening:!opening_key in
      S.Response.make_string (Ok 
        (String.concat " "[
        "\nBob's Opening Key: ";(!opening_key);
        "\nBob's Tool:";(tool_to_string(tool_of_string ot));
        "\nAlice's Tool:";(tool_to_string !my_tool);
        "\nDual outcome:";(result !my_tool (tool_of_string ot))
        ]))
    );


  (* echo request *)
  S.add_route_handler server
    S.Route.(exact "echo" @/ return)
    (fun req -> 
      S.Response.make_string (Ok (Format.asprintf "commitment: %s" req.body)));
      (* S.Response.make_string (Ok (Format.asprintf "echo:@ %a@." S.Request.pp req))); *)
    
  Printf.printf "listening on http://%s:%d\n%!" (S.addr server) (S.port server);
  match S.run server with
  | Ok () -> ()
  | Error e -> raise e


















(* open Lwt

(* Shared mutable counter *)
let counter = ref 0

let listen_address = Unix.inet_addr_loopback
let port = 9000
let backlog = 10


let handle_message msg =
    match msg with
    | "read" -> string_of_int !counter
    | "inc"  -> counter := !counter + 1; "Counter has been incremented"
    | _      -> "Unknown command"

let rec handle_connection ic oc () =
    Lwt_io.read_line_opt ic >>=
    (fun msg ->
        match msg with
        | Some msg -> 
            let reply = handle_message msg in
            Lwt_io.write_line oc reply >>= handle_connection ic oc
        | None -> Logs_lwt.info (fun m -> m "Connection closed") >>= return)

let accept_connection conn =
    let fd, _ = conn in
    let ic = Lwt_io.of_fd ~mode:Lwt_io.Input fd in
    let oc = Lwt_io.of_fd ~mode:Lwt_io.Output fd in
    Lwt.on_failure (handle_connection ic oc ()) (fun e -> Logs.err (fun m -> m "%s" (Printexc.to_string e) ));
    Logs_lwt.info (fun m -> m "New connection") >>= return

let create_socket () =
    let open Lwt_unix in
    let sock = socket PF_INET SOCK_STREAM 0 in
    bind sock @@ ADDR_INET(listen_address, port) |> (fun x -> ignore x);
    listen sock backlog;
    sock

let create_server sock =
    let rec serve () =
        Lwt_unix.accept sock >>= accept_connection >>= serve
    in serve *)
