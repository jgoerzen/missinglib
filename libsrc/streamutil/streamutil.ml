(*pp camlp4o *)
(* arch-tag: Stream parser-related utilities
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

open Composeoper;;

let rec of_channel_lines ifd = 
  match (try Some (input_line ifd) with End_of_file -> None) with
      None -> [< >]
    | Some line -> [< 'line; of_channel_lines ifd >];;

let of_channel_blocks ifd blocksize = 
  let buf = String.make blocksize '\000' in
  let rec forceread bytestoread = 
    if bytestoread = 0 then 0 else begin
      let len = input ifd buf (blocksize - bytestoread) bytestoread in
      if len = 0 then len else len + forceread (bytestoread - len)
    end
  in
  let rec worker () =
    let len = forceread blocksize in
    if len = 0 then [< >] else
      [< '(String.sub buf 0 len); worker () >]
  in
  worker () ;;

let rec filter func = parser
    [< 'x; xs >] -> if func x then [< 'x; filter func xs >] else 
      [< filter func xs >]
  | [< >] -> [< >];;

let rec map func = parser
    [< 'x; xs >] -> [< 'func x; map func xs >]
  | [<  >] -> [< >];;

let rec map_stream func = parser
    [< 'x; xs >] -> [< func x; map_stream func xs >]
  | [< >] -> [< >];;

let rec fold_left func firstval = parser
    [< 'x; xs >] -> fold_left func (func firstval x) xs
  | [< >] -> firstval;;

let rec to_list = parser
    [< 'x; xs >] -> x :: to_list xs
  | [< >] -> [];;

let rec take n s = 
  let p = parser [< 'x; xs >] -> [< 'x; take (n - 1) xs >] in
  match n with
    0 -> [< >]
  | n -> if n < 1 then raise (Failure "take stream") else p s;;

let rec drop n s = match n with
  0 -> ()
  | n -> if n < 1 then raise (Failure "drop stream") else Stream.next s; drop (n-1) s;;

let output_lines ofd s = 
  Stream.iter (fun line -> output_string ofd line; output_char ofd '\n') s;;

let output_chars ofd s =
  Stream.iter (fun c -> output_char ofd c) s;;

let rec optparse func accum args = match try Some (func args) with
Stream.Failure ->
  None with
  None -> (List.rev accum)
| Some x -> optparse func (x :: accum) args;;

let rec optparse_1 funchead functail accum args =
  (* Note: :: appears to evaluate right side first!  Use this let to force left
   * side to go first instead. *)
  let item1 = funchead args in
  item1 :: optparse functail accum args;;

let optparse_1_folded func combinefunc startval args =
   let result = optparse_1 func func [] args in
   List.fold_left combinefunc startval result;;

let optparse_1_string func args =
  optparse_1_folded func (^) "" args;;

