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

(** Stream parser utilities *)

(** This function is useful for parsing zero or more occurances of a certain
    element.

    @param func The parser function.  Will be called repeatedly until
                Stream.Error is raised.
    @param accum Accumulator -- pass [] to it to start with.
    @param args Passed to func.
    @return A list of return values from func; may be empty.
*)
let rec optparse func accum args = match try Some (func args) with
Stream.Failure ->
  None with
  None -> (List.rev accum)
| Some x -> optparse func (x :: accum) args;;

(** Same as optparse, but forces to match at least once.  funchead is applied
    to the first element; functail to all the rest.
    
    @param funchead Function to apply to first element
    @param functail Function to apply to remaining arguments
    @param accum Accumulator -- pass [] to start with
    @param args Passed to the various functions
*)
let rec optparse_1 funchead functail accum args =
  (* Note: :: appears to evaluate right side first!  Use this let to force left
   * side to go first instead. *)
  let item1 = funchead args in
  item1 :: optparse functail accum args;;

(** Used to do something that happens once or more, and folds the results.
* Uses optparse_1 internally.
* @param func Parser function
  @param combinefunc Combination function used for folding
  @param startval Starting value for folding
  @param args Parser arguments *)
let optparse_1_folded func combinefunc startval args =
   let result = optparse_1 func func [] args in
   List.fold_left combinefunc startval result;;

(** Utility function used to generate strings; equivolent to
*   optparse_1_folded func (^) "" args
*   @param func Parser function
    @param args Arguments *)
let optparse_1_string func args =
  optparse_1_folded func (^) "" args;;

