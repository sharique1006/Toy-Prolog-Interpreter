open Prolog

let main () = begin   
    let filename = Sys.argv.(1) in
	let file_handle = open_in filename in
	let lexbuf = Lexing.from_channel file_handle in
    let program = Parser.interpreter Lexer.token lexbuf in
    (*print_program program;*)
    let lexbuf = Lexing.from_channel stdin in
        while true do
            print_string "| ?- ";
            flush stdout;
            flag := 0;
            continue := 0; 
            vlist := [];
            let goals = Parser.goals Lexer.token lexbuf in
            (*print_goals goals;*)
            solve program goals;
        done
end;;

main();;

(*
let rec print_term t = match t with
    |   V(a) ->  print_string"V(\""; print_string a; print_string "\""; print_string")"; 
    |   C(a) ->  print_string"C(\""; print_string a; print_string "\""; print_string")"; 
    |   _ -> print_string ""
;;

let rec print_term_list f = match f with
    |   []      ->  print_string ""
    |   a::b    ->  print_term a; (if List.length b != 0 then print_string "; "); print_term_list b
;;

let rec print_subst (s:substitution) = match s with
    | [] -> print_string "\nSUBST\n\n";
    | (t1,t2) :: xs -> print_string "("; print_term t1; print_string " "; print_term t2; print_string ")"; (if List.length xs != 0 then print_string ";"); print_subst xs 
;;   

let print_atomic f = match f with
    |   Atom(a, b)    ->  print_string"Atom(\""; print_string a; print_string "\", ["; print_term_list b; print_string"])";
;;    

let rec print_body f = match f with
    |   []      ->  print_string ""
    |   a::b    ->  print_atomic a; (if List.length b != 0 then print_string "; "); print_body b
;;    

let print_head f = match f with
    |   AF(a)    ->  print_string"AF("; print_atomic a; print_string")";
;;    

let print_rule f = match f with
    |   HB(a, AFL(b))    ->  print_string"HB("; print_head a; print_string"); AFL("; print_body b; print_string")";
;;    

let print_fact f = match f with
    |   H(a)    ->  print_string"H("; print_head a; print_string")";
;;    

let print_clause c = match c with
    |   F(a)    ->  print_string"F("; print_fact a; print_string")"
    |   R(a)    ->  print_string"R("; print_rule a; print_string")"
;;    

let rec print_clause_list c = match c with
    |   []      ->  print_string "])\n"
    |   a::b    ->  print_clause a; (if List.length b != 0 then print_string"; "); print_clause_list b
;;  
let print_program p = match p with
    |   P(a)    ->  print_string"P(Cl(["; print_clause_list a; print_string")"
;;

let print_goals p = match p with
    |   G(a)    ->  print_string"G("; print_body a; print_string")"
  ;;
*)
