(* arch-tag: ounit utilities
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

let rec mapassert_equal msg f = function
  [] -> ()
| x :: xs -> (assert_equal ~msg:msg (f (fst x)) (snd x);
              mapassert_equal msg f xs);;

let string_printer (x:string) = x;;

let rec mapassert_equal_str msg f = function
    [] -> ()
  | x :: xs -> (assert_equal ~msg:msg ~printer:string_printer (snd x) (f (fst x));
                mapassert_equal_str msg f xs);;

let test_mapassert_equal () =
  mapassert_equal "test1" (fun x -> if x < 10 then x else x + 10)
    [(1, 1); (5, 5); (8, 8)];;
  assert_raises (Failure "OUnit: test2\nnot equal") (fun _ ->
    mapassert_equal "test2" (fun x -> if x < 10 then x else x + 10)
      [(1, 1); (5, 6)]);;

let suite = "testutil" >::: ["mapassert_equal" >:: test_mapassert_equal];;

let string_equal msg x y = assert_equal ~printer:string_printer ~msg:msg x y;;

let str_list_printer (x:string list) = 
  "[" ^ (String.concat "; " x) ^ "]";;
let slist_equal msg x y = assert_equal ~printer:str_list_printer
   ~msg:msg x y;;

let sslist_equal msg x y = slist_equal msg
  (List.sort compare x) (List.sort compare y);;
