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

You can use AnyDBM in your own code with code like this:

{[open AnyDBM_Interface;;
let db = AnyDBM_Dbm.opendbm "/tmp/foo" [Dbm_rdonly] 0o644;;
close db;;]}

Standard modules implementing the AnyDBM interface include:
- {!AnyDBM_String}, uses the persistent storage in {!Hashtblutil}
- {!AnyDBM_Dbm}, uses the system's Dbm module.  Available only on systems that have the Dbm module available.

The interface in this module is designed to be a drop-in replacement for the
system's Dbm module.  You can, in fact, replace [open Dbm] with
[open AnyDBM_Interface], and adjust your [opendbm] calls, and have a
transparent replacement.
*)

(** {5 Typs and Exceptions} *)

(** Flags used for opening a database. *)
type anydbm_open_flag = {
  read: bool;                       (** Whether reading is permitted *)
  write: bool;                      (** Whether writing is permitted *)
  create: bool;                     (** Whether to create a non-existing file *)
}

(** Flags for historic compatibility with Dbm. *)
type open_flag = 
  | Dbm_rdonly                          (** Read-only mode *)
  | Dbm_wronly                          (** Write-only mode *)
  | Dbm_rdwr                            (** Read/write mode *)
  | Dbm_create                          (** Create file if it doesn't exist *)
    
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

(** {5 Standard Functions} *)

(** Close the connection to the database, saving any
      unsaved changes.  {b NOTE: AnyDBM modules are not guaranteed to write
      out their data unless you call close!} *)
val close: t -> unit

(** Returns the data associated with the given key or raises 
  [Not_found] if the key is not present. *)
val find: t -> string -> string

(** Adds the key/data pair given.  Raises
  {!AnyDBM_Interface.Dbm_error}[ "Entry already exists"]
  if the key is already present. *)
val add: t -> string -> string -> unit


(** Add the key/value pair to the database, replacing any existing
  pair with the same key. *)
val replace: t -> string -> string -> unit

(** Remove the key/value pair with the given key.  If there is no such key,
    raises {!AnyDBM_Interface.Dbm_error}[ "dbm_delete"]. *)
val remove: t -> string -> unit


(** [iter f db] applies f to each (key, data) pair in the database db.  f
  receives key as frist argument and data as second argument. *)
val iter: (string -> string -> unit) -> t -> unit

(** {6 Utilities for AnyDBM module implementators} *)
module AnyDBMUtils: sig

  (** Given flags of the style open_flag, return a new-style anydbm_open_flag
  *)
  val flags_old_to_new: open_flag list -> anydbm_open_flag

  (** Given flags of anydbm_open_flag, return old-style open_flag *)
  val flags_new_to_old: anydbm_open_flag -> open_flag list

  (** Given flags of the new style, return flags for Pervasives open_gen
    functions.  The flagbase parameter should be [Open_rdonly] or
    [Open_wronly] depending on whether you are reading or writing primarily.
  *)
  val flags_new_to_open: anydbm_open_flag -> Pervasives.open_flag -> Pervasives.open_flag list

  (** Utility class for implementators *)
  class virtual anyDBM_Base : anydbm_open_flag -> 
  object
    method private can_write : bool
    method private can_read : bool
    method private assert_write : unit
    method private assert_read : unit
      
    method private virtual do_add : string -> string -> unit
    method add: string -> string -> unit

    method private virtual do_find: string -> string
    method find: string -> string

    method private virtual do_replace: string -> string -> unit
    method replace: string -> string -> unit

    method private virtual do_remove: string -> unit
    method remove: string -> unit

    method private virtual do_iter: (string -> string -> unit) -> unit
    method iter: (string -> string -> unit) -> unit
  end

end
