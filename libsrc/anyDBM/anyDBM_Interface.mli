(* arch-tag: Generic DBM interface support, interface file
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

(** {6 Generic interface for DBM modules}

This module is used to provide a generic interface to various local flat-file
modules in OCaml.  Various AnyDBM implementations will use these definitions.
*)

(** Flags used for opening a database.  See
{!AnyDBM.Interface.t}. *)

type open_flag = Dbm_rdonly | Dbm_wronly | Dbm_rdwr | Dbm_create

class type t = 
object
  method close : unit
  method find : string -> string
  method add : string -> string -> unit
  method replace: string -> string -> unit
  method remove: string -> unit
  method iter: (string -> string -> unit) -> unit
end

exception Dbm_error of string

val close: t -> unit
val find: t -> string -> string
val add: t -> string -> string -> unit
val replace: t -> string -> string -> unit
val remove: t -> string -> unit
val iter: (string -> string -> unit) -> t -> unit

