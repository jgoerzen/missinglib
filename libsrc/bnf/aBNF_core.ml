(*pp camlp4 -I . -I ./camlp4 -I ../camlp4 pa_o.cmo pa_bparser.cmo pr_dump.cmo *)
(* arch-tag: ABNF core rules
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

open Strutil;;
open Streamutil;;
open BNFparseutil;;

let alpha = bparser
    [< x = (range ~i:false [R(chr(0x41), chr(0x5a)); R(chr(0x61), chr(0x7a))]) >]
              -> x

and bit = bparser
    [< x = range ~i:false [C '0'; C '1'] >] -> x

and char = bparser
    [< x = range ~i:false [R(chr(0x01), chr(0x7f))] >] -> x

and cr = bparser
    [< ''\x0d' >] -> '\x0d';;

let lf = range ~i:false [C('\x0a')];;

let crlf = bparser
    [< x = cr; y = lf >] -> string_of_charlist([x; y]) 

and ctl = bparser
    [< x = range ~i:false [R(chr(0x00), chr(0x1f)); C(chr(0x7f))] >] -> x

and digit = range ~i:false [R(chr(0x30), chr(0x39))]

and dquote = range ~i:false [C('\x22')];;

let hexdig = bparser
    [< x = digit >] -> x
|   [< x = range ~i:true [R('A', 'F')] >] -> x

and htab = range ~i:false [C('\x09')];;

let sp = range ~i:false [C('\x20')];;

let wsp = bparser
  [< x = sp >] -> x
| [< x = htab >] -> x;;

let lwsp = optparse (bparser 
                       [< x = wsp >] -> x
                    |  [< crlf; x = wsp >] -> x)
;;

let octet = range ~i:false [R('\x00', '\xff')]

and vchar = range ~i:false [R('\x21', '\x7e')];;

