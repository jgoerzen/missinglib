(* arch-tag: ABNF core rules, interface definition
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

(** ABNF Parser Core Definitions from RFC2234

@author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org>

*)

open Stream

(** A-Z / a-z *)
val alpha: char t -> char

(** "0" / "1" *)
val bit: char t -> char

(** %x01-7F, any 7-bit ASCII character except for %x00 *)
val char: char t -> char

(** carriage return, %x0D *)
val cr: char t -> char

(** CR/LF, Internet standard newline *)
val crlf: char t -> string

(** controls: %x00-1F/ %x7F *)
val ctl: char t -> char

(** digits: 0-9 *)
val digit: char t -> char

(** Double quote *)
val dquote: char t -> char

(** Hex digits: 0-9, A-F, case-insensitive *)
val hexdig: char t -> char

(** Horizontal tab *)
val htab: char t -> char

(** Linefeed, %x0A *)
val lf: char t -> char

(** Linear white space (past newline), [*(WSP / CRLF WSP)] *)
val lwsp: char t -> string

(** 8-bit data *)
val octet: char t -> char

(** Space *)
val sp: char t -> char

(** Visible (printing) characters *)
val vchar: char t -> char

(** White space, [SP / HTAB] *)
val wsp: char t -> char
