(* arch-tag: Generic DBM interface support
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
type open_flag = Dbm_rdonly | Dbm_wronly | Dbm_rdwr | Dbm_create;;

exception Dbm_error of string;;

(** Implementations of AnyDBM must provide an implementing object
of type t. *)
class type t =
object

  (** Close the connection to the database, saving any
      unsaved changes. *)
  method close : unit

  (** Returns the data associated with the given key or raises Not_found
    if the key is not present. *)
  method find : string -> string

  (** Adds the key/data pair given.  Raises Dbm_error "Entry already exists"
    if the key is already present. *)
  method add : string -> string -> unit

  (** Add the key/value pair to the database, replacing any existing
    pair with the same key. *)
  method replace: string -> string -> unit

  (** Remove the key/value pair with the given key.  If there is no key,
    raise Dbm_error "dbm_delete". *)
  method remove : string -> unit

  (** iter f db applies f to each (key, data) pair in the database db.  f
  receives key as frist argument and data as second argument. *)
  method iter : (string -> string -> 'a) -> unit
end;;

let close db = db#close ();;
let find db = db#find;;
let add db = db#add;;
let replace db = db#replace;;
let remove db = db#remove;;
let iter db = db#iter;;
