(* arch-tag: config parser lexer for interpolation
*)
{
  open Lexing;;
  open Strutil;;
  exception Eof;;
}

let interp_var_pat = [^ ')']+
let interp_start = '%' '('
let interp_end = ')' 's'
let interp_string = interp_start (interp_var_pat as interpvar) interp_end
let std_string = [^ '\\' '%']+

let escaped_pct = "\\%"

rule loken interpfunc = parse
  escaped_pct   { ("%") }
| interp_string { interpfunc(interpvar) }
| std_string as x  { (x) }
| eof { raise Eof }
| _ as x        { (string_of_char x) }

