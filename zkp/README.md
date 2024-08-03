# ocaml_rock_paper_scissors
 An OCaml implementation of a secure client-server rock-paper-scissors game

---
author: Ofer Rivlin   
email: ofer.rivlin@intel.com
---

## Switch
    $ opam switch create ccc ocaml-base-compiler.5.0.0
    $ opam switch ccc

## Dependencies
    $ opam install lwt logs nocoiner conduit-lwt cohttp-lwt-unix tiny_httpd
 
## How to use
    $ cd zkp

    $ dune build

For regular “Rock/Scissors/Paper” RANDOM APP game run:
    $ dune exec rps_game


For regular “Rock/Scissors/Paper” *Regular* Client-Server game:
  1. Uncomment the *REGULAR* section and comment-out the *COMMITMENT* section in “client_main.ml” file.
  2. Save the file.
  3. Launch one shell and run the command:
      $ dune exec rps_server
  4. Launch a second shell and run the command:
      $ dune exec rps_client


For regular “Rock/Scissors/Paper” *Commitment* Client-Server game run:
  1. Uncomment the * COMMITMENT * section and comment-out the * REGULAR* section in “client_main.ml” file.
  2. Save the file.
  3. Launch one shell and run the command:
      $ dune exec rps_server
  4. Launch a second shell and run the command:
      $ dune exec rps_client
  5. Continue run "$ dune exec rps_client" , until you get the result: "Dual outcome: Alice loses" or "Dual outcome: tie"

## Run examples

### Regular RANDOM game:
(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml/zkp$ dune build
(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml/zkp$ dune exec rps_game
                                    
What's Bob's tool? (r/p/s)r

Your tool: Rock
Alice's tool: Scissors
Dual outcome: Alice loses

### Launch server:
(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml/zkp$ dune exec rps_server
listening on http://127.0.0.1:8080  


### On another shell run client:

#### first without commitment, Alice always wins

(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml$ cd zkp
(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml/zkp$ dune exec rps_client
                                    
Chosen Tool Response:

Bob's tool: Rock 
Alice's tool: Paper 
Dual outcome: Alice wins

(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml/zkp$ dune exec rps_client
                                    
Chosen Tool Response:

Bob's tool: Paper 
Alice's tool: Scissors 
Dual outcome: Alice wins

#### second with commitment

(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml/zkp$ dune exec rps_client
                                    
=========================================================

Commit Response: 

Bob's Commitment:

 Z0RUamJtSWZvWjVJcGNpa3VOVW5WSHNRTGlwMDl2YjkwZk00SDV0N2tpcU1qRVBCSk02MytXUjJuLy9kUFRzV3RVeGNaTDNQUGY0NGZrM0U5a0hZQ3c9PQ==@sl3gMlZ7e+Ahcrx0rgjRqw==@GoUEd3h9ktsEkVZjejGF8Q==@mW8DXKP+3hcIe8Tng7Tdo+XFz2FL55HIISouDOEgYvKp1rgR4OXb9MvBZffQHVlh0wEP4m8soFFZsEJLwtdAHw== 

Alice's Tool: Scissors

=========================================================

Opening Response: 

Bob's Opening Key:  17/XBt0Pw2reM0ka5CzRmFeZgkG904Qmia0Ut/9bA/s= 
Bob's Tool: Scissors 
Alice's Tool: Scissors 
Dual outcome: tie

=========================================================

(ccc) ubuntu@ip-172-31-32-183:~/workspace/orivlin.confidential_computing_class_ocaml/zkp$ dune exec rps_client
                                    
=========================================================

Commit Response: 

Bob's Commitment:

 UHBrOTVXdzhnNE5tTW02Vk53bWQ2eEFmeVdLcXBWTzRRU0tVSlVaS3haOFFoeGVtNkgxbGVyMkw2OHJHTk5LaTNVaXJraDF1SzVXWGsvOVVRa0dBQXc9PQ==@omszcvqo3x7+Xm+sGFLgIQ==@dyQ45pnbfRjEud9wLHfxkA==@hgJBfwS36Cz+XV3Xki82wE1yw3woubXRAJbkzJzdmFSfJH/EUOrq73nEq4kc6GgQZGVJSG6tUyADyZu2FT2utg== 

Alice's Tool: Paper

=========================================================

Opening Response: 

Bob's Opening Key:  iIxLid/H0pQN0DaGdLoijafyO1VCC7Tw/kiy0T7Hmns= 
Bob's Tool: Scissors 
Alice's Tool: Paper 
Dual outcome: Alice loses

=========================================================
