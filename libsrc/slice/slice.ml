(* arch-tag: slices of sequences of things
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

type slice_finish_t = EndOfList | EndingOffset of int | Position of int;;
type slice_t = (int * slice_finish_t);;
let slice_end = max_int;;

let slice_of_pair (pair:int * int) =
  let x = fst pair and y = snd pair in
  (x, if y < 0 then
    (EndingOffset (-y))
  else (if y = slice_end then
    (EndOfList)
  else
    (Position y)));;

let subvalues_of_slice (s:slice_t) len =
  let start = fst s and
  finish = match snd s with 
    EndOfList -> len
  | EndingOffset x -> len - x
  | Position x -> x in
  if (start < 0) then (raise (Invalid_argument "Slice.subvalues_of_slice"));
  if (finish > len) || (finish < 0) || (finish < start) then
    (raise (Invalid_argument "Slice.subvalues_of_slice"));
  if start = finish then (0, 0) else
    (start, (finish - start));;

let generic_slice subfunc lenfunc item (slice:slice_t) =
  let subv = subvalues_of_slice slice (lenfunc item) in
  subfunc item (fst subv) (snd subv);;

let string_slice = generic_slice String.sub String.length;;
let array_slice item s = generic_slice Array.sub Array.length item s;;
let list_slice item s = generic_slice Listutil.sub List.length item s;;
