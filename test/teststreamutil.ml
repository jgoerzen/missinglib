(*pp camlp4o *)
(* arch-tag: tests for streamutil
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
open Streamutil;;
open Composeoper;;

let infstream () = let rec gen n = [< 'n; gen (succ n) >] in gen 0;;
let finstream () = let gen n = [< 'n; 'n+1; 'n+2; 'n+3; 'n+4 >] in gen 0;;

let test_to_list () =
  assert_equal ~msg:"finstream" [0; 1; 2; 3; 4]
    (to_list (finstream ()));
  assert_equal ~msg:"emptystream" []
    (to_list [< >]);;

let test_take () =
  let s = infstream () in 
  assert_equal ~msg:"infstream" [0; 1; 2]
    (to_list % take 3 $ s);
  assert_equal ~printer:string_of_int 3 (Stream.next s);
  assert_raises Stream.Failure (fun () -> take 4 [< >]);;

let test_drop () =
  let s = infstream () in
  drop 5 s;
  assert_equal ~msg:"drop" ~printer:string_of_int 5 (Stream.next s);
  assert_raises Stream.Failure (fun () -> drop 5 [< >]);;

let test_filter () =
  let s = filter (fun x -> x mod 2 = 0) (infstream ()) in
  assert_equal ~msg:"inf" [0; 2; 4; 6] (to_list % take 4 $ s);
  let s = filter (fun x -> x mod 2 = 0) (finstream ()) in
  assert_equal ~msg:"fin" [0; 2; 4] (to_list s);
;;

let test_map () =
  let s = map string_of_int (finstream ()) in
  assert_equal ~msg:"map" ["0"; "1"; "2"; "3"; "4"] (to_list s);;

let test_fold_left () =
  let s = map string_of_int (finstream ()) in
  assert_equal ~msg:"foldl1" 10 (fold_left 
                                   (fun prev elem -> prev + (int_of_string elem))
                                   0 s);
  assert_equal ~msg:"emptyfoldl" 42 (fold_left (fun x y -> x + y) 42 [< >]);;

let suite = "teststreamutil" >:::
              ["to_list" >:: test_to_list;
               "take" >:: test_take;
               "drop" >:: test_drop;
               "filter" >:: test_filter;
               "fold_left" >:: test_fold_left;
               "map" >:: test_map];;

