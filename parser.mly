%{
  open Prolog
%}

%token <string>VAR
%token <string>ID
%token IFF
%token AND OR
%token PERIOD
%token LPAREN RPAREN RBRAC LBRAC
%token EOF ERROR

%start goals 
%start interpreter
%type <Prolog.goal> goals
%type <Prolog.program> interpreter

%%
interpreter: 
           | program EOF                                                {P($1)}
           ;

goals:                                     
     | atomic_formula_list PERIOD                                       {G($1)}
     ;

program: 
       | clause                                                         {[$1]}
       | clause program                                                 {$1 :: $2}
       ;

clause: 
      | fact                                                            {F($1)}
      | rule                                                            {R($1)}
      ;

fact: 
    | head PERIOD                                                       {H($1)}
    ;

rule:
    | head IFF body PERIOD                                               {HB($1, $3)}
    ;

head:
    | atomic_formula                                                    {AF($1)}    
    ;

body:
    | atomic_formula_list                                               {AFL($1)}
    ;

atomic_formula_list: 
                   | atomic_formula                                     {[$1]}
                   | atomic_formula AND atomic_formula_list             {$1 :: $3} 
                   | atomic_formula OR atomic_formula_list              {$1 :: $3}
                   ;
atomic_formula: 
              | ID LPAREN term_list RPAREN                              {Atom($1, $3)}
              ;

term_list: 
         | term                                                         {[$1]}
         | term AND term_list                                           {$1 :: $3}
         ;

term: 
    | ID                                                                {C($1)}
    | VAR                                                               {V($1)}
    | ID LPAREN term_list RPAREN                                        {Node($1, $3)}  
    ;