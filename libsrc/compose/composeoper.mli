(* arch-tag: Composition operator interface
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

(** Function Composition

This module provides basic support for functions supporting function
composition. *)

(** Calling (f % g) x is equivolent to calling f(g(x)). *)
val (%): ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b

(** (g %% f) x is the same as f(g(x)). *)
val (%%): ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c

(** This will apply a function. *)
val ($): ('a -> 'b) -> 'a -> 'b
