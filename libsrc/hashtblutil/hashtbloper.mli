(* arch-tag: Hash table operators interface
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

(** Hash table convenience operators

These are operators to help make your work with hash tables easier.  For other
utitilies, see also the {!Hashtblutil}.

Unlike the functions in {!Hashtblutil}, all of these operators are
{b non-destructive}.  That is, they do not modify the hash tables on which
they operate, but rather return a new hash table that represents the result.
This leads to the most natural behavior for an operator. *)

(** Shorcut to get an element from a hash.  The following: {[
  hash /> 5 ]}

is the same as: {[
  Hashtbl.find hash 5 ]}

This can be combined to form more powerful constructs.  Consider this example: {[
  let sections = Hashtbl.create 5;;
  let options = Hashtbl.create 5;;
  Hashtbl.replace options "option1" "value1";;
  Hashtbl.replace sections "section1" options;;
  sections /> "section1" /> "option1";;
     returns "value1" ]} *)
val (/>): ('a, 'b) Hashtbl.t -> 'a -> 'b

(** Add (merge) two hashes.  For instance, this: {[
   hash1 /+ hash2 ]}

Returns a new hash (hash1 and hash2 are unmodified).  It will contain
all key/value pairs in either hash.  If any pairs are duplicated, the
values in hash2 take precedence. *)
val (/+): ('a, 'b) Hashtbl.t -> ('a, 'b) Hashtbl.t -> ('a, 'b) Hashtbl.t

(** Returns a new hash that has the given (key, value) pair added to the hash
passed in.  If a duplicate key is given, the new pair takes precedence.

For example: {[
  let newhash = hash // ("key", "value");; ]}

This will return a new hash that has the elements of [hash] plus one more. *)
val (//): ('a, 'b) Hashtbl.t -> 'a * 'b -> ('a, 'b) Hashtbl.t
