(* arch-tag: tests for hashtblutil
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

open OUnit;;
open Testutil;;
open Hashtbl;;
open Hashtblutil;;

let makehash () =
  let h = Hashtbl.create 10 in
  replace h "red" "blue";
  replace h "green" "yellow";
  replace h "black" "white";
  h;;

let test_map () =
  (* FIXME: WRITE ME! *)
  ();;

let test_keys () =
  let l = (keys (makehash ())) in
  let r = List.sort compare l in
  assert_equal r ["black"; "green"; "red"];;

let test_values () =
  let l = (values (makehash ())) in
  let r = List.sort compare l in
  assert_equal r ["blue"; "white"; "yellow"];;

let test_items () =
  let l = (items (makehash ())) in
  assert_equal ~msg:"length" 3 (List.length l);
  mapassert_equal "content" (fun key -> List.assoc key l)
    ["black", "white"; "green", "yellow"; "red", "blue"];;
  
let test_merge () =
  (* FIXME: WRITE ME *)
  ();;

let test_str () =
  let s = str_of_stritem "black\n" "white" in
  assert_equal ~msg:"first" "\"black\\n\":\"white\"\n" s;
  assert_equal ~msg:"result" ("black\n", "white")
    (stritem_of_str s);;

let suite = "testhashtblutil" >:::
  ["map" >:: test_map;
   "keys" >:: test_keys;
   "values" >:: test_values;
   "items" >:: test_items;
   "merge" >:: test_merge;
   "str" >:: test_str;
  ];;

