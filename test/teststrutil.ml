(* arch-tag: tests for strutil
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
open Strutil;;

let test_lstrip () =
  mapassert_equal "lstrip" lstrip
    ["", ""; "a", "a"; " a ", "a "; "  abas", "abas";
     "\n\t fdsa", "fdsa"; "abc def", "abc def"];;

let test_rstrip () =
  mapassert_equal "rstrip" rstrip
    ["", ""; "a", "a"; " a ", " a"; "abas  ", "abas";
     "fdsa \n\t", "fdsa"; "abc def", "abc def"];;

let test_strip () =
  mapassert_equal "strip" strip
    ["", ""; "a", "a"; " a ", "a"; "abas  ", "abas"; "  abas", "abas";
     "asdf\n\t ", "asdf"; "\nbas", "bas"; "abc def", "abc def"];;

let test_string_of_char () =
  mapassert_equal "string_of_char" string_of_char
    [' ', " "; 'a', "a"; '\n', "\n"];;

let test_split_ws () =
  assert_equal ~msg:"empty" [] (split_ws "   ");
  assert_equal ~msg:"null" [] (split_ws "");
  assert_equal ~msg:"single" ["asdf"] (split_ws " asdf\n");
  assert_equal ~msg:"several" ["one"; "two"; "three"] (split_ws "  one\ntwo \tthree \n");
;;


let suite = "teststrutil" >:::
  ["lstrip" >:: test_lstrip; 
   "rstrip" >:: test_rstrip;
   "strip" >:: test_strip;
   "split_ws" >:: test_split_ws;
    "string_of_char" >:: test_string_of_char ];;

