(*pp camlp4o *)
(* arch-tag: BNF parser utilities
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

open Stream;;

type repatt = C of char | R of char * char;;

let optparse func args =
  Strutil.string_of_charlist (Streamutil.optparse func [] args);;

let optparse_1 funchead args =
  Strutil.string_of_charlist (Streamutil.optparse_1 funchead funchead [] args);;

let test_char_patt patt c = match patt with
    C x -> c = x
  | R (x, y) -> x <= c && c <= y;;

let rec test_range pattlist c = match pattlist with
    [] -> false
  | x :: xs -> if test_char_patt x c then true else test_range xs c;;

let range pattlist stream =
  match Stream.peek stream with
      None -> raise Stream.Failure
    | Some c -> (if test_range pattlist c then (Stream.junk stream; c)
                 else raise Stream.Failure);;

let range_n pattlist stream =
  match Stream.peek stream with
      None -> raise Stream.Failure
    | Some c -> (
        if not (test_range pattlist c) then (Stream.junk stream; c)
        else raise Stream.Failure);;
(*
let s_or test1 test2 istream =
  try begin
    let cstream = new BNFSupport.lazyStream istream in
    let retval = test1 cstream in
    cstream#consume_stream;
    retval
  end with Stream.Failure | Stream.Error _ -> begin
    let cstream = new BNFSupport.lazyStream istream in
    let retval = test2 cstream in
    cstream#consume_stream;
    retval;
  end;
;;
*)

let s_and predlist istream =
  if predlist = [] then raise (Stream.Error "Predicate list empty in s_and")
  else begin
    let procitem item =
      let cs = new BNFSupport.lazyStream istream in
      (cs, item cs) in
    let processed = List.map procitem prodlist in
    (fst (hd processed))#consume_stream;
    List.map snd processed;
  end;;

let eof = String.empty;;
