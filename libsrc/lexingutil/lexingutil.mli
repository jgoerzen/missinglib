(* arch-tag: lexing-relating utilities, interface file
Copyright (C) 2004 John Goerzen <jgoerzen@complete.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

(** Lexing-related utilities
*
* These functions are designed to assist with ocamllex lexers or anything
* that uses the built-in Lexing module.*)

(** This exception is designed to be raised by your code when an error
* occurs during lexing or parsing.  The {!Lexingutil.raise_syntax_error}
* function will raise this exception as well. *)
exception ParsingSyntaxError of string

(** countline is useful if you desire accurate line numbers for your error
* messages.  The standard Lexing library does not properly update position
* information.
*
* You can use countline in a rule in your .mll file.  For instance,
* this comes from the {!ConfigParser} module: {[
rule loken = parse
  eol { countline lexbuf; loken lexbuf }
]}

This will cause the end-of-line (the eol pattern is defined outside this
example) to increase the counter but then be otherwise ignored. *)
val countline: Lexing.lexbuf -> unit

(** This function raises a {!Lexingutil.ParsingSyntaxError}.  It combines
* the given message with the given position to generate an error message that
* give the offset, line number, and character number of the error.
*
You can use it from a parser like this: {[
  | error { raise_syntax_error "ConfigParser" (Parsing.symbol_start_pos () ) }
]}

Or, from a lexer like this: {[
| (_) as error { raise_syntax_error "ConfigParser" (lexeme_start_p lexbuf) }
]}

The result will look like this: {[
ConfigParser: Syntax error in <unknown>, at or before offset 6 (line 2, char 1)]} *)
val raise_syntax_error: string -> Lexing.position -> 'a

