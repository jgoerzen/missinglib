(* arch-tag: slice operators mli file
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

(** Flexible subparts of arrays, lists, and strings

The Sliceoper and Slice modules help you grab parts of arrays, lists, and
strings.  For those familiar with Python, this mechanism is patterned after
Python's indexing features.  The mechanism is also generalizable to any other
type that provides support for sub and length functions of the same manner
as the Array, String, and List (plus {!Listutil} from this library) modules.

It is recommended the modules that will be using slices should load the
Sliceoper module with:

  {[open Sliceoper;;]}

to make the operators conveniently available.

{6 Slice Basics}

A slice via this module
contains two parts: a start position and an end position.  Position 0
corresponds to the start of the list (or string, whatever).  The end position
is the index of the last item plus one.  Therefore, a slice from 0 to 2
would return the first two elements: elements 0 and 1.

The end position can also be negative.  In that case, it means to leave off the
given number of items from the end of the list.  For instance, if you had the
string "abcdefg" and took the slice from 0 to -1, you would obtain "abcdef".
If you took the slice from 1 to -3, you'd get "bcd".

You can also omit the end position to obtain the entire item starting from the
given start position.  There are special operators for this case; see below.

These features, taken together, make it easy to obtain certain internal parts
of arrays, lists, or strings without requiring multiple calls to sub and
manual length calculations. *)


(** {6 Slice Composition Operator} *)

(** |> is the slice composition operator, and is designed to work solely 
in conjunction with one of the slice application operators below.  That is,
you can {b not} just say [let x = 1 |> 3;;] and expect a valid result (see the 
{!Slice} module
if you wish to do this).

An example usage would be:

{["abcdefg" |$ 1 |> 3;;
  string = "bc" ]}
*)
val (|>): (int -> 'a) -> int -> 'a


(** {6 Slice Application Operators}

The slice application operators are used to apply a slice to a string,
array, or list.  They are designed to be used together with the slice
composition operator documented above.*)

(** String application operator.  Example usage:

  {[string |$ 1 |> -1;;]}

  This strips the first and last characters off the string. *)
val (|$): string -> int -> int -> string

(** List application operator.  Example usage:

  {[list |@ 1 |> -1;;]}

  This strips the first and last elements from the list. *)
val (|@): 'a list -> int -> int -> 'a list


(** Array application operator.  Example usage:

  {[array |& 1 |> -1;;]}

  This strips the first and last elements from the array. *)
val (|&): 'a array -> int -> int -> 'a array

(** {6 Remainder-Of-Items Application Operators}

These operators are designed to take no ending position, instead taking only
a starting position.  Therefore, the |> operator should not be used separately.
*)

(** String operator.  Example usage:
  
  {[string |$> 1;;]}

   This strips the first character from the string. *)
val (|$>): string -> int -> string


(** List operator.  Example usage:
  
  {[list |@> 1;;]}

  This strips the first character from the list. *)
val (|@>): 'a list -> int -> 'a list

(** Array operator.  Example usage:

  {[array |&> 1;;]}

  This strips the first character from the array. *)
val (|&>):  'a array -> int -> 'a array
