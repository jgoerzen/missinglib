(* arch-tag: Stream parser interface file *)
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

val optparse: ('a -> 'b) -> 'b list -> 'a -> 'b list
val optparse_1: ('a -> 'b) -> ('a -> 'b) -> 'b list -> 'a -> 'b list
val optparse_1_folded: ('a -> 'b) -> ('c -> 'b -> 'c) -> 'c -> 'a -> 'c
val optparse_1_string: ('a -> string) -> 'a -> string

val of_channel_lines: in_channel -> string Stream.t
val filter: ('a -> bool) -> 'a Stream.t -> 'a Stream.t
val map: ('a -> 'b) -> 'a Stream.t -> 'b Stream.t
val to_list: 'a Stream.t -> 'a list
val take: int -> 'a Stream.t -> 'a Stream.t
val drop: int -> 'a Stream.t -> unit
