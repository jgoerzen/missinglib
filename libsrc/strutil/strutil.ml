(* arch-tag: String utilities main file
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

open Composeoper;;

let wschars = [' '; '\t'; '\r'; '\n'];;
let wsregexp = Str.regexp "[ \n\t]+";;

let rec lstrip s = 
  if String.length s < 1 then s else
  if List.mem (String.get s 0) wschars then
    lstrip (String.sub s 1 ((String.length s) - 1))
  else
    s;;

let rec rstrip s =
  if String.length s < 1 then s else
    let len = String.length s in
    if List.mem (String.get s (len - 1)) wschars then
      rstrip (String.sub s 0 (len - 1))
    else
      s;;

let strip = lstrip %% rstrip;;

let string_of_char = String.make 1;;

(** @param delim A string giving the delimiter
*   @param s The string to split *)
let split delim s = Str.split_delim (Str.regexp_string delim) s;;

let join = String.concat;;

let split_ws instr = Str.split wsregexp (strip instr);;

let trunc x len =
  if String.length x > len then begin
    String.sub x 0 len
  end else x;;
