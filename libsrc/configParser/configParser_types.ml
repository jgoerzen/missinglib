(* arch-tag: config parser low-level types
Copyright (C) 2004 John Goerzen
<jgoerzen@complete.org>

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

open Hashtbl;;
open Hashtblutil;;

type configsection = (string, string) Hashtbl.t;;
type configfile = (string, configsection) Hashtbl.t;;
let make_file () = ((Hashtbl.create 10):configfile);;
let make_section () = ((Hashtbl.create 10):configsection);;

let rec convert_list hash optionxform = function
  [] -> ()
|  x :: xs -> replace hash (optionxform (fst x)) (snd x);
              convert_list hash optionxform xs;;

let convert_list_section filehash sectname optionlist optionxform =
  if not (mem filehash sectname) then
    replace filehash sectname (make_section ());
  convert_list (find filehash sectname) optionxform optionlist;;

let rec convert_list_file hash optionxform = function
  [] -> ()
| x :: xs -> convert_list_section hash (fst x) (snd x) optionxform;
             convert_list_file hash optionxform xs;;

let string_of_value v =
  Strutil.join "\n    " (Strutil.split "\n" v);;

let string_of_options hash = 
  let rec string_of_key = function
    [] -> ""
  | key :: xs -> (key ^ ": " ^ (string_of_value (find hash key)) ^ "\n") ^ 
                 (string_of_key xs) in
  string_of_key (List.sort compare (keys hash));;

(** Convert a section to a string, but don't emit the DEFAULT section if it is
* not given. *)
let string_of_section sectname opthash =
  if sectname = "DEFAULT" && length opthash = 0 then
    ""
  else
    "[" ^ sectname ^ "]\n" ^ (string_of_options opthash) ^ "\n";;


let string_of_file hash = 
  let rec string_of_sections = function
    [] -> ""
  | key :: xs -> string_of_section key (find hash key) 
                 ^ string_of_sections xs in
  string_of_sections (List.sort compare (keys hash));;
