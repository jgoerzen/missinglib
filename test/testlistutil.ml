(* arch-tag: tests for listutil
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
open Listutil;;

let test_remove_assoc_all () =
  let f key l = remove_assoc_all l key in
  mapassert_equal "remove_assoc_all" (f "testkey")
    [[], [];
     ["one", 1], ["one", 1];
     ["1", 1; "2", 2; "testkey", 3], ["1", 1; "2", 2];
     ["testkey", 1], [];
     ["testkey", 1; "testkey", 2], [];
     ["testkey", 1; "2", 2; "3", 3], ["2", 2; "3", 3];
     ["testkey", 1; "2", 2; "testkey", 3; "4", 4], ["2", 2; "4", 4]
    ];;

let test_replace () =
  let f key value l = replace l key value in
  mapassert_equal "replace" (f "testkey" 101)
    [[], ["testkey", 101]
    ];;

let suite = "testlistutil" >:::
  ["test_remove_assoc_all" >:: test_remove_assoc_all;
   "test_replace" >:: test_replace];;

