(* arch-tag: slices of sequences of things, interface file
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

(** Underlying API for Slice operators

This module is inteded to be used by people implementing slices over new
data types.  {b Most people should be using the {!Sliceoper} module instead.}
Please see the {!Sliceoper} module for a basic description of what slices are
and how they work.  This module implements the layer underlying
{!Sliceoper} and is generally of interest only if you wish to extend
the Slice system yourself. *)

(** {6 Types and Constants} *)

(** The type of the "finish" part of a slice tuple. *)
type slice_finish_t =
  EndOfList     (** Signifies no endpoint; go to the end of the items *)
| EndingOffset of int    (** Signifies a specific offset from the end of a
                             list.  Note this is given as a positive number
                             here even though it is given as a negative number
                             in {!Sliceoper}. *)
| Position of int        (** Signifies a position from the start of the list *)

(** The basic slice type.  The first element is the start position; the second
is the ending position. *)
type slice_t = (int * slice_finish_t)

(** A special value that signifies the end of the list.  This is used
by the {!Slice.slice_of_pair} function. *)
val slice_end: int

(** {6 Conversion Function} *)

(** This function takes an integer (start, end) tuple and returns
a slie_t.  The first item is moved over directly.  If the second item is
negative, it is made positive and is taken as an EndingOffset.  If it's equal
to {!Slice.slice_end}, it is taken as an EndOfList.  Otherwise, it is taken as
a Position. *)
val slice_of_pair: int * int -> slice_t

(** {6 Built-in Slice Functions}

These functions apply the slice to a data object and return the result. *)

val string_slice: string -> slice_t -> string
val list_slice: 'a list -> slice_t -> 'a list
val array_slice: 'a array -> slice_t -> 'a array

(** {6 Slice builder function} *)

(** This function is used to create a new slice function.  As an example,
here is the full code for [string_slice]:

  {[let string_slice = generic_slice String.sub String.length;;]}

The function takes four parameters: a "sub" function, a "length" function,
an item, and a slice.
*)
val generic_slice: ('a -> int -> int -> 'a) -> ('a -> int) -> 'a -> slice_t -> 'a
