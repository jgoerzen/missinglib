(* arch-tag: Documentation for pa_bparser *)
(*
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

(** Backtracking Parser Syntax Extension *)

(** {1 Introduction}

NOTE: THIS MODULE IS ONLY USABLE AS A CAMLP4 EXTENSION; SEE BELOW FOR
DETAILS.

The standard camlp4 system comes with the syntax extension [pa_op.cmo] which
adds support for the [parser] keyword to the OCaml language.

This is nice, but it lacks backtracking.  Here is an illustration of
the problem.  Assume you have the following parser defined:

{[let p = parser 
  [< '3; '1; '4 >] -> "hey" 
| [< '3; '4 >] -> "there";;]}

Calling the parser with the stream [[< '3; '1; '4 >]] will produce the result
["hey"] as expected.  However, calling it with the stream [[< '3; '4 >]] will
produce an error.

The built-in [parser] will use only the first element in a stream to determine
which of the alternative rules to pursue.  Since the first element here is
[3], it will choose the first stream; the second one will be completely
ignored.

The [pa_bparser] module is a complete replacement for [pa_op].  It supports
everything [pa_op] does but adds a new keyword: [bparser].  A [bparser] is
defined just like a [parser], but it supports a key feature: backtracking.
Thus, it solves this problem.  You could define your parser like this:

{[let p = bparser
  [< '3; '1; '4 >] -> "hey" 
| [< '3; '4 >] -> "there";;]}

and it will work as expected.

{1 Use}

This module defines the [ocamlfind] module [missinglib.pa_bparser].  You can
use it like this:

{[ocamlfind ocamlc -linkpkg -o test -package missinglib.pa_bparser -syntax camlp4o test.ml]}

*)
