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

(** {6 General Parsing Utilities} *)

(** Used to ensure that all conditions are met at the same point on a stream.
Takes a list of stream parsers that all return the same type of data and
evaluates them all.  If all succeed (don't raise any exceptions), then a list
of results from those parsers is returned.

Note: It is extremely important that you make all your conditions consume the
same amount of data from the stream.  Otherwise, undefined results will occur.
*)
val s_and: ('a Stream.t -> 'b) list -> 'a Stream.t -> 'b list

(** Useful to testing to see if the end-of-file has been reached.  This is an
alias for [Stream.empty]. *)
val eof: 'a Stream.t -> unit

(** {6 Character-Specific Parsing Utilities} *)

(** Default value for case-insensitive comparisons.  Defaults to false,
    meaning comparisons are case-sensitive.  Optional [i] arguments
    to functions in this module take a bool specifying whether or not
    to use case-insensitive comparisons.  The default value for [i] in
    those functions is this value. *)
val insens: bool

(** Used for parsing character ranges *)
type repatt =
    C of char                           (** Match a single character *)
  | R of char * char                    (** Match a single character within the inclusive range of the two characters given *)

(** Stream parser: find a single character in the given range. *)
val range: ?i:bool -> repatt list -> char Stream.t -> char

(** Stream parser: find any character NOT in the given range. *)
val range_n: ?i:bool -> repatt list -> char Stream.t -> char

(** Returns the character given by the specified integer; an alias for
    [Char.chr]. *)
val chr: int -> char

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


