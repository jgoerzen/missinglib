(* arch-tag: config parser lexer
*)
{
  open Lexing;;
  open Lexingutil;;
  open ConfigParser_parser;;
  open Lexingutil;;
  let string_of_char = String.make 1;;
}

let comment_chars = ['#' ';']
let eol = ('\n' | "\r\n" | '\r')
let optionsep = [':' '=']
let whitespace_chars = [' ' '\t']
let comment_line = (whitespace_chars)* comment_chars [^ '\r' '\n']+
let empty_line = (whitespace_chars)+
let sectheader_chars = [^']' '\r' '\n']
let sectheader = '[' ((sectheader_chars+) as sname) ']' 
let oname_chars = [^':' '=' '\r' '\n']
let value_chars = [^'\r' '\n']
let extension_line = whitespace_chars+ (([^'\r' '\n' '#' ';'] (value_chars*)) as extension)

let optionkey = ((oname_chars+) as oname)
let optionvalue = ((value_chars+) as value)
let optionpair = optionkey optionsep optionvalue

rule loken = parse
  eol { countline lexbuf; loken lexbuf } 
| comment_line { loken lexbuf }
| empty_line { loken lexbuf }

| sectheader { NEWSECTION(sname) }
| optionpair { NEWOPTION(oname, value) }
| extension_line { EXTENSIONLINE(extension) }
| eof { EOFTOK }
| (_) as error { raise_syntax_error "ConfigParser" (lexeme_start_p lexbuf) }

