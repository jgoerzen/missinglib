(* arch-tag: BNF parse utilities interface file *)
(*
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

(** Character parsing utilities

@author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org>
*)

(** Used for parsing character ranges *)
type repatt =
    C of char                           (** Match a single character *)
  | R of char * char                    (** Match a single character within the inclusive range of the two characters given *)

(** Stream parser: find a single character in the given range. *)
val range: repatt list -> char Stream.t -> char

(** Stream parser: find any character NOT in the given range. *)
val range_n: repatt list -> char Stream.t -> char

(** This function is useful for parsing zero or more occurances of a certain
    element.  Similar to {!Streamutil.optparse}, but works only on
    character strings and returns a string.

    @param func The parser function.  Will be called repeatedly until
                Stream.Failure is raised.
    @param args Passed to func.
    @return A string; may be empty.
*)
val optparse: ('a -> char) -> 'a -> string

(** Same as optparse, but forces to match at least once.  funchead is applied
    to the first element; functail to all the rest.  Similar to
    {!Streamutil.optparse_1}, but works only on character strings and
    returns a string.
    
    @param funchead Function to apply to all arguments
    @param args Passed to the various functions
*)
val optparse_1: ('a -> char) -> 'a -> string


