(* arch-tag: String utilities mli file
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

(** String-related utilities.
*
* This module provides various helpful utilities for dealing with strings.
* @author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org> 
*)

(** {6 Whitespace removal} 
 * These functions are designed to remove extra whitespace from the start
 * and end of strings.  For the purposes of these functions, whitespace
 * characters are defined as space, tab, carriage return, and line feed.
 *)

(** Removes any whitespace characters that are present at the start or
* end of a string.  Does not alter the internal contents of a string.  If
* no whitespace characters are present at the start or end of a string,
* returns the original string unmodified.  Safe to use on any string.
*
* Note that this may differ from some other similar functions from
* other authors in that:
  *
  * 1. If multiple whitespace characters are present all in a row, they
  * are all removed;
  *
  * 2. If no whitespace characters are present, nothing is done. *)
val strip: string -> string

(** Same as strip, but applies only to the left side of the string. *)
val lstrip: string -> string

(** Same as strip, but applies only to the right side of the string. *)
val rstrip: string -> string

(** {6 Conversions} *)

(** Splits a string into multiple component strings.
*   
*   Similar to Str.split_delim.
*
*   Example: {[
# split ":" ":jgoerzen::foo:bar:";;
  string list = [""; "jgoerzen"; ""; "foo"; "bar"; ""] ]} *)
val split: string -> string -> string list

(** Splits a string deliminted by whitespace into multiple component
strings.  Leading or trailing whitespace is ignored. *)
val split_ws: string -> string list

(** Makes one output string from the given string list by inserting
* the delim between each element.  An alias for String.concat. 
*   @return A list of strings.  Each item in the list is one that as
*   separated by delim.  The delim itself will never appear in the list.
*   Empty strings may be in the list of one instance of delim immediately
*   followed by another, or if delim occured at the beginning or end of
*   a string. *)
val join: string -> string list -> string

(** Given a char, returns a one-character string composed of that character.
*
* For instance, [string_of_char 'c'] would produce ["c"].
*)
val string_of_char: char -> string

(** Given a list of characters, returns a string composed of the characters
in that list.  For instance, [string_of_charlist ['h'; 'i']] would produce
["hi"]. *)
val string_of_charlist: char list -> string

(** Given a string and a length, truncates the string to have, at most,
len characters.  If the string is shorter that the given len, it is 
returns unmodified. *)
val trunc: string -> int -> string
