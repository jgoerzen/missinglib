(*pp camlp4 -I . -I ./camlp4 -I ../camlp4 pa_o.cmo pa_bparser.cmo pr_dump.cmo *)
(* arch-tag: ABNF Defintion
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
open ABNFcore;;

type rule_t = {rulename: string; ruleelements: string};;

let rec rulelist istream = 
  let reslist = Streamutil.optparse_1 (bparser
     [< x = rule >] -> Some x
   | [< c_wsp; c_nl >] None) istream in
  let filtered = List.filter (fun x -> match x with Some _ -> true | None -> false) reslist in
  List.map (fun x -> match x with Some y -> y | None -> raise (Error "error")) filtered

and rule = bparser
  [< n = rulename; defined_as; e = elements; c_nl >] -> 
    {rulename = n; ruleelements = e }

and rulename = bparser
  [< first = alpha;
     remainder = optparse (bparser [< x = alpha >] -> x
                          |        [< x = digit >] -> x
                          |        [< ''-' >] -> '-') >] ->
    ((char_of_string first) ^ remainder)

and defined_as = bparser
  [< optparse c_wsp; x = ''='; optparse c_wsp >] -> x
| [< optparse c_wsp; x = 

;;

let octet = range ~i:false [R('\x00', '\xff')]

and vchar = range ~i:false [R('\x21', '\x7e')];;

