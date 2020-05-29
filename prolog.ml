type symbol = string
type variable = string
type constant = string
type term = V of variable | C of constant | Node of symbol * (term list)
type substitution = (term * term) list

type atomic_formula = Atom of symbol * (term list)
type head = AF of atomic_formula;;
type body = AFL of atomic_formula list;;
type fact = H of head;;
type rule = HB of head * body;;
type clause = F of fact | R of rule;; 
type program = P of clause list;;
type goal = G of atomic_formula list;;

exception NOT_UNIFIABLE
exception ERROR;;

let flag = ref 0 ;;
let continue = ref 0 ;;
let vlist = ref []

(*Function to find the Constant variable when the term matches with the variable of substitution*)
let rec replaceH (x:term) (s:substitution) = match s with
    | [] -> []
    | (V(c), C(d)) :: b  -> if x = V(c) then C(d) :: replaceH x b
                            else replaceH x b

    | a::b -> replaceH x b
;;

(*Function to find a term which replaces a given variable i.e. always returns a Constant*)
let replace (t:term) (subst:substitution) =  let h = replaceH t subst in
                                                match h with   
                                                    | [] -> t
                                                    | a::b -> a
;;

(*Prints the answers to goal*)
let rec displayH t k s = match t with
    | [] -> print_string ""; flush stdout; k
    | a::b -> match a with
                |(V(x), f) ->  let displayHH r = match r with 
                                    | V(v) -> displayH b k s 
                                    | Node(sym, tl) -> displayH b k s
                                    | C(v) -> let b1 = List.exists(fun element -> V(x) = element) !vlist in 
                                                if b1 then 
                                                    (flag := 1; print_string (x ^ " = " ^ v ^ " "); displayH b 1 s)
                                                else
                                                (displayH b 1 s)
                                            in
                                            displayHH (replace f s)
                |(_, _) -> print_string ""; flush stdout; displayH b k s
;;

(*Function to display the answers when goal is a variable*)
let display (s : substitution) = let y = displayH s 0 s in 
                                    if y = 0 then (true,s) else (false,[])
;;

(*Given two terms add the pair to substitution list*)
let compose t1 t2 subst = match (t1,t2) with
    | V(x),_ -> (t1,t2) :: subst
    | _,V(x) -> (t2,t1) :: subst
    | _,_ -> raise ERROR
;;

(*Function to the substitution by composing the terms*)
let rec unify (t1, t2 : term*term) (subst : substitution) = match (t1, t2) with
        | C(a), C(b) -> if a = b then (true,subst) else (false,[]) 
        | V(a), _ -> let t = compose t1 t2 subst in (true,t)
        | _, V(a) -> let t = compose t2 t1 subst in (true,t)
        | _,_ -> (false,[]) 
;;

(*Function which returns a term if the term is variable find corresponding constant using replace else return the term*)
let rec substituteH (s:substitution) (t : term) = match t with
    | V(a) -> let r = replace t s in r
    | C(a) -> t 
    | _ -> t
;;

(*Function to substitute the variables*)
let rec substitute (tl : term list) (s : substitution) = match tl with
    | [] -> []
    | x :: xs -> (substituteH s x) :: (substitute xs s) 
;;

(*Given two atomic formula list find the substitution*)
let rec solveAF l m (subst:substitution) = match (l,m) with
    | [],[] -> (true,subst)
    | [], e::f | e::f, [] -> (false,[]) 
    | e::f, g::h -> let t = unify (e,g) subst in
                    match t with
                        | (false,d) -> (false,[]) 
                        | (true,d) -> solveAF f h d
;;

(*Given the clause list, For each clause in the clause list solve the goal till we get true or false
match the goal, clause pair and find the corresponding substitution*)
let rec solveClause (cl, subst : clause list * substitution) (g : atomic_formula list) (c : clause) = match g with
    | [] -> (true,subst)
    | g :: gs -> match (c,g) with
            | F(H(AF(Atom(sym1, tl1)))), Atom(sym2, tl2) -> if sym1=sym2 && List.length tl1 = List.length tl2 then
                                                                 let tl1 = substitute tl1 subst in 
                                                                 let tl2 = substitute tl2 subst in 
                                                                 let t = solveAF tl2 tl1 subst in
                                                                 let fn y = match y with
                                                                    | (false,x) -> (false,[]) 
                                                                    | (true,x) -> solveGoals (cl, x) gs
                                                                 in fn t
                                                            else (false,[])
            | R(HB(AF(Atom(sym1, tl1)), AFL(b))), Atom(sym2, tl2) -> if sym1=sym2 && List.length tl1 = List.length tl2 then
                                                                     let t = solveAF tl2 tl1 subst in
                                                                     match t with
                                                                        | (false,x) -> (false,[]) 
                                                                        | (true,x) -> solveGoals (cl, x) (b @ gs)
                                                                     else (false,[])
and
solveGoals (cl, subst : clause list * substitution) (goals : atomic_formula list) = match goals with
    | [] -> if (!continue) != 0 then
                (print_string " ? ";
                let y = read_line() in
                if y = ";" then (display subst)
                else (true,subst)
               )
            else (continue := 1; display subst)
    | a :: b -> walkClauseList (solveClause (cl, subst) (goals)) cl
and
walkClauseList f l = match l with
    | [] -> (false,[])
    | a::b -> let t = f a in
              let func t = match t with 
                    | (false,a) -> walkClauseList f b
                    | (true,a) -> t
              in
              func t 
;;

(*Given a term list get all the variables present in it*)
let rec vars (tl : term list) = match tl with
    | [] -> []
    | x :: xs -> match x with
                | V(x) -> V(x) :: vars xs
                | _ -> vars xs
            ;;

(*Given an atomic formula list get the list of all variables present in it*)
let rec varsAFL af = match af with
    | [] -> []
    | Atom(a,b) :: c -> vars b @ varsAFL c
;;

(*Main Function to solve the goal*)
let solve (p:program) (g:goal) = match (p,g) with
    | P(cl), G(b) -> vlist := varsAFL b;
                    let y = solveGoals (cl,[]) b in
                    match y with
                        | (false,x) -> if !flag = 0 then (print_string "false\n";)
                                else (print_string "true\n";)
                        | (true,x) -> print_string "true\n";
                    ;;