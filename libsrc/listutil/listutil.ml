(* arch-tag: list utilities implementation
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

(** *)
open List;;

let rec remove_assoc_all l key =
  if mem_assoc key l then
    remove_assoc_all (remove_assoc key l) key
  else
    l;;

(** @param l List to work with
* @param key Key to add
* @param value Value to add
* @return New list with a [(key, value)] pair added, replacing any existing
* pair with the same key. *)
let replace l key value =
  (key, value) :: remove_assoc_all l key;;

(** @raise Invalid_argument If the start and len arguments are invalid
* with respect to each other or the size of the list, 
* [Invalid_argument "Listutil.sub"] is raised. *)
let sub l start len =
  (* Removes start elements from the beginning of the list and returns the
      result.  start must be >= 0. *)
  let rec sub_chop_start lst start =
    if start = 0 then lst else
      sub_chop_start (tl lst) (start - 1) in
  let rec sub_max_len accum lst len =
    if len = 0 then List.rev accum else
      sub_max_len ((hd lst) :: accum) (tl lst) (len - 1) in

  if (start < 0) || (len < 0) || (start + len > length l) then
    raise (Invalid_argument "Listutil.sub")
  else
    sub_max_len [] (sub_chop_start l start) len;;
   
let rec take n l = match n with
    0 -> []
  | n -> if n < 1 then raise (Failure "take list") else hd l :: take (n-1) (tl l);;

let rec drop n l = match n with 
    0 -> l
  | n -> if n < 1 then raise (Failure "drop list") else drop (n-1) (tl l);;

let output_lines ofd l = 
  iter (fun line -> output_string ofd line; output_char ofd '\n') l;;

let output_chars ofd l =
  iter (fun c -> output_char ofd c) l;;
