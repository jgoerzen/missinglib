(* arch-tag: lexing-related utilities
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

open Lexing;;

exception ParsingSyntaxError of string;;

let countline (lb:lexbuf) =
  lb.lex_curr_p <- {lb.lex_curr_p with pos_lnum = lb.lex_curr_p.pos_lnum + 1};;

let raise_syntax_error msg (pos:position) =
  let locstr = 
    Printf.sprintf "%s: Syntax error in %s, at or before offset %d (line %d, char %d)" 
      msg
      (if String.length pos.pos_fname> 0 then pos.pos_fname else "<unknown>")
      (pos.pos_cnum + 1) (pos.pos_lnum + 0) (pos.pos_bol + 1) in
  raise (ParsingSyntaxError locstr);;

