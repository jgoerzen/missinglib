(* arch-tag: config parser lexer for interpolation
*)
{
  open Lexing;;
  open Lexingutil;;
  open ConfigParser_interp_parser;;
  open Lexingutil;;
  open Strutil;;
}

let interp_var_pat = [^ ')']+
let interp_start = '%' '('
let interp_end = ')' 's'
let interp_string = interp_start (interp_var_pat as interpvar) interp_end
let std_string = [^ '\' '%']+

let escaped_pct = '\\' '%'

rule loken = parse
  escaped_pct   { NORMALSTR("%") }
| interp_string { INTERPVAR(interpvar) }
| std_str as x  { NORMALSTR(x) }
| _ as x        { NORMALSTR(string_of_char x) }

