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
open Hashtbloper;;
open Composeoper;;

let merge original newitems =
  let mergef = replace original in
  iter mergef newitems;;

let map f hash = Hashtbl.fold (fun key value l -> (f key value) :: l) hash [];;
let keys hash = map (fun key value -> key) hash;;
let values hash = map (fun key value -> value) hash;;
let items hash = map (fun key value -> key, value) hash;;
let length hash = (keys %% List.length) hash;;

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

let str_of_stritem key value = 
  Printf.sprintf "%S,%S\n" key value;;

let stritem_of_str instr =
  Scanf.sscanf instr "%S,%S" (fun k v -> k,v);;
  
let strhash_to_ochan hasht ochan =
  Hashtbl.iter (fun k v -> output_string ochan (str_of_stritem k v)) hasht;;

let ichan_to_strhash ichan = 
  let hasht = create 5 in
  let s = Streamutil.of_channel_lines ichan in
  Stream.iter (fun line -> let v = stritem_of_str line in
                 add hasht (fst v) (snd v)) s;
  hasht;;
