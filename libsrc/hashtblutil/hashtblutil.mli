(* arch-tag: Hash table utilities interface
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

(** Hash table utilities

This module provides various functions to simplify working with OCaml standard
hash tables (standard library module Hashtbl).  For additional features
and convenience operators, see the {!Hashtbloper} module. *)

(** {6 Hash Table Information}

These functions are used to extract information from hash tables in various
ways. *)

(** Calling [keys hash] will return a list of all the keys contained in
that hash. *)
val keys: ('a, 'b) Hashtbl.t -> 'a list

(** Calling [values hash] will return a list of all the valies contained
in that hash. *)
val values: ('a, 'b) Hashtbl.t -> 'b list

(** Calling [length hash] will return the number of keys present in the
* hash. *)
val length: ('a, 'b) Hashtbl.t -> int

(** Calling [items hash] will return a list of pairs representing all
the (key, value) pairs present in the hash.  This list is suitable for use
with the association list functions in the standard module [List] or the
Missinglib module {!Listutil}. *)
val items: ('a, 'b) Hashtbl.t -> ('a * 'b) list

(** Calling [map func hash] will call [func key value] for each key/value
pair represented in the hash, and return a list of the return values from
func.  As an example, here is the implementation of the 
{!Hashtblutil.keys} function: {[
let keys hash = map (fun key value -> key) hash;; ]} *)
val map: ('a -> 'b -> 'c) -> ('a, 'b) Hashtbl.t -> 'c list

(** {6 Hash Table Conversion}

These functions alter a hash table in various ways.

Please note that they {b modify the table in-place}; that is, they do not
return a new hash table but rather modify the one passed in as an argument. *)

(** Calling [merge oldhash newhash] will iterate over the newhash.  Each
key/value pair present in it will be added to the oldhash using
[Hashtbl.replace].  Therefore, the entire contents of the new hash will
be added to the old one, replacing any key with the same name that is already
present. *)
val merge: ('a, 'b) Hashtbl.t -> ('a, 'b) Hashtbl.t -> unit

(** This function is used to adjust the keys in a hash table.  For example, it
may be used to convert all keys to lowercase in a hash table indexed by
strings.  Calling [convkeys hash func] will call func for every key in the
hash.  If [func] returns a key different than the key passed to it, the
relevant key in the hash table will be renamed, overwriting any key with
the same name as the new key.  It is not necessarily possible to predict what
which key/value pair will "win" in this case.

Your [func] must be such that it returns its argument unmodified if passed an
already-converted value.

Here is an example: {[
convkeys myhash String.lowercase ]}

This is used, for instance, when you wish the keys of your hash to be
case-insensitive; you can then use String.lowercase before any call to hash
lookup/modification functions. *)
val convkeys: ('a, 'b) Hashtbl.t -> ('a -> 'a) -> unit
