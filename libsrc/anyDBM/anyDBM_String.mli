(* arch-tag: AnyDBM module for on-disk string tables, interface definition
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

(** {6 Simple Storage of Hashtable-like objects on disk}

This module is a wrapper around the persistent storage features in
{!Hashtblutil}.  It is available on all systems.

For usage examples, please see {!AnyDBM_Interface}.
*)

open AnyDBM_Interface;;
open Hashtbl;;

class dbm: string -> anydbm_open_flag -> int -> 
object
  inherit AnyDBMUtils.anyDBM_Base
  method private do_close: unit
  method private do_add: string -> string -> unit
  method private do_find: string -> string
  method private do_replace: string->string->unit
  method private do_remove: string->unit
  method private do_iter: (string -> string -> unit) -> unit
end

val opendbm : string -> open_flag list -> int -> dbm
