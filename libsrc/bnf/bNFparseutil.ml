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

let insens = false;;

type repatt = C of char | R of char * char;;

(* Transforms the character to the lowercase format if case-insensitivty is
used. *)
let cx isinsens c =
  if isinsens then Char.lowercase c else c;;

let optparse func args =
  Strutil.string_of_charlist (Streamutil.optparse func [] args);;

let optparse_1 funchead args =
  Strutil.string_of_charlist (Streamutil.optparse_1 funchead funchead [] args);;

let test_char_patt ?(i=insens) patt c = 
  let c = cx i c in
  match patt with
    C x -> c = (cx i x)
  | R (x, y) -> (cx i x) <= c && c <= (cx i y);;

let rec test_range ?(i=insens) pattlist c = match pattlist with
    [] -> false
  | x :: xs -> if test_char_patt ~i:i x c then true else test_range ~i:i xs c;;

let range ?(i=insens) pattlist stream =
  match Stream.peek stream with
      None -> raise Stream.Failure
    | Some c -> (if test_range ~i:i pattlist c then (Stream.junk stream; c)
                 else raise Stream.Failure);;

let range_n ?(i=insens) pattlist stream =
  match Stream.peek stream with
      None -> raise Stream.Failure
    | Some c -> (
        if not (test_range ~i:i pattlist c) then (Stream.junk stream; c)
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

let chr = Char.chr;;

let s_and predlist istream =
  if predlist = [] then raise (Stream.Error "Predicate list empty in s_and")
  else begin
    let procitem item =
      let cs = new BNFsupport.lazyStream istream in
      (cs, item cs#to_stream) in
    let processed = List.map procitem predlist in
    (fst (List.hd processed))#consume_stream;
    List.map snd processed;
  end;;

let mstring ?(i=insens) s istream = 
  let comparisonstream = Stream.of_string s in
  let cs = new BNFsupport.lazyStream istream in
  let rec p checkdata instream =
    match checkdata with 
        [] -> []
      | x :: xs -> begin
          let y = Stream.next instream in
          if not ((cx i y) = (cx i x)) then raise Stream.Failure else
            x :: (p xs instream)
        end
  in
  let res = p (Streamutil.to_list comparisonstream) cs#to_stream in
  cs#consume_stream;
  Strutil.string_of_charlist res;;

let eof = Stream.empty;;
