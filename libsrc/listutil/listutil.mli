(* arch-tag: list utilities interface file
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

(** List-manipulation utilities *)

(** {6 Association List Utilities}
 *
 * These functions are designed to augment the standard "Association lists"
 * functions in the standard library List.  Association lists are lists
 * of pairs where the first item is a key and the second item is a value.
 * These utilities add functions similar to those you may find in the standard
 * module Hashtbl to work with association lists. *)

(** Calling [replace l key value] will add a [(key, value)] pair to the list.
* If any pair with the same key already exists, it will be removed.  Therefore,
* this function can be thought of as doing the same task as the Hashtbl
* module's replace function. *)
val replace: ('a * 'b) list -> 'a -> 'b -> ('a * 'b) list

(** Calling [remove_assoc_all l key] will remove all pairs from list l
* with a key matching the given value, and returns the result. *)
val remove_assoc_all: ('a * 'b) list -> 'a -> ('a * 'b) list

(** {6 Sub-List Selection} *)

(** This function behaves identically to the standard Array.sub or String.sub
* functions, but operates on lists.  Given a call of [sub l start len],
* a list with [len] elements will be returned, with elements starting at
* [start] (where element 0 is the first element). *)
val sub: 'a list -> int -> int -> 'a list

(** This function returns the first n elements of the given list.

Raises Failure on invalid arguments or if n is greater than the length of the
list. *)
val take: int -> 'a list -> 'a list

(** This function removes the first n elements from the given list and
returns the remaining elements.

Raises Failure on invalid arguments or if n is greater than the length of
the list. *)
val drop: int -> 'a list -> 'a list

(** {6 Processing Utilities}

These functions do something with a list. *)

(** Given a list of lines, output a line containing each element from the list.
The list is expected to not have newlines; those will be added automatically.
*)
val output_lines: out_channel -> string list -> unit

(** Given a list of chars, output the characters representing each element
from the list. *)
val output_chars: out_channel -> char list -> unit
