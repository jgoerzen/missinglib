(* arch-tag: operators for working on slices
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

open Slice;;

(** Utility function *)
let slicemaker func item x y = func item (slice_of_pair (x, y));;

let (|>) func (y:int) = func y;;

let (|$) item x = slicemaker string_slice item x;;

let (|@) item x = slicemaker list_slice item x;;

let (|&) item x = slicemaker array_slice item x;;

let (|$>) item x = string_slice item (x, EndOfList);;

let (|@>) item x = list_slice item (x, EndOfList);;

let (|&>) item x = array_slice item (x, EndOfList);;

