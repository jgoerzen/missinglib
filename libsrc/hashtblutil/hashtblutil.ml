(* arch-tag: Hash table utilities implementation
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

open Hashtbl;;

let merge original newitems =
  let mergef = replace original in
  iter mergef newitems;;

let map f hash = Hashtbl.fold (fun key value l -> (f key value) :: l) hash [];;
let keys hash = map (fun key value -> key) hash;;
let values hash = map (fun key value -> value) hash;;
let items hash = map (fun key value -> key, value)  hash;;
let length hash = List.length (keys hash);;

let convkeys hasht convfunc =
  let doconv key value = 
    let newkey = convfunc key in
    if newkey != key then
      remove hasht key;
      replace hasht newkey value in
  iter doconv hasht;;

let convkeys_copy hasht convfunc =
  let newhash = copy hasht in
  convkeys newhash convfunc;
  newhash;;

