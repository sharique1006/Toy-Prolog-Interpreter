{
  open Parser
}

let string = ['a'-'z'] ['_' 'a'-'z' 'A'-'Z' '0'-'9']*
let var = ['A'-'Z'] ['_' 'a'-'z' 'A'-'Z' '0'-'9']*

rule token = parse
  | [' ' '\t' '\n']      { token lexbuf }
  | ":-"            { IFF }
  | ';'             { OR }
  | '('             { LPAREN }
  | ')'             { RPAREN }
  | '['             { LBRAC }
  | ']'             { RBRAC }
  | ','             { AND }
  | '.'             { PERIOD }
  | string  as s    { ID (s) }
  | var   as s      { VAR (s) }
  | eof             { EOF }
  | _               { ERROR }