(* arch-tag: Generic DBM interface support
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

type anydbm_open_flag = { read: bool; write: bool; create: bool };;

type open_flag = Dbm_rdonly | Dbm_wronly | Dbm_rdwr | Dbm_create;;


exception Dbm_error of string;;

(** Implementations of AnyDBM must provide an implementing object
of type t.  The details of this class are not important for regular AnyDBM
users.  Methods of this class correspond to the standard functions in
{!AnyDBM_Interface}.  Please refer to those functions for documentation
on these methods. *)
class type t =
object

  method close : unit
  method find : string -> string
  method add : string -> string -> unit
  method replace: string -> string -> unit
  method remove : string -> unit
  method iter : (string -> string -> unit) -> unit
end;;


let close (db:t) = db#close;;
let find (db:t) = db#find;;
let add db = db#add;;
let replace db = db#replace;;
let remove db = db#remove;;
let iter func (db:t) = db#iter func;;

module AnyDBMUtils =
struct
  let flags_old_to_new flaglist = 
    let setfl x fl = match fl with
        Dbm_rdonly -> {x with read = true; write = false}
      | Dbm_wronly -> {x with read=false; write = true}
      | Dbm_rdwr -> {x with read=true; write = true}
      | Dbm_create -> {x with create = true} in
    List.fold_left setfl {read = false; write = false; create = false} flaglist;;

  let flags_new_to_old flags = 
    let base = match (flags.read, flags.write) with
        true, false -> Dbm_rdonly
      | false, true -> Dbm_wronly
      | true, true -> Dbm_rdwr
      | false, false -> raise (Dbm_error "Can't convert flags with no I/O operation") in
    base :: (if flags.create then [Dbm_create] else []);;

  let flags_new_to_open flag openbase =
    let base = match (flag.read, flag.write) with
        true, false -> Open_rdonly
      | false, true -> Open_wronly
      | true, true -> openbase
      | false, false -> raise (Dbm_error "Can't convert flags with no I/O operation") in
    base :: (if flag.create then [Open_creat] else []);;

  class virtual anyDBM_Base (flag_parm:anydbm_open_flag) =
  object (self)
    (* inherit t *)
    val mutable flag = flag_parm

    method private can_write = flag.write
    method private can_read = flag.read
    method private assert_write =
      if not self#can_write then raise (Dbm_error "database not open for writing")
    method private assert_read = 
      if not self#can_read then raise (Dbm_error "database not open for reading")

    method private virtual do_add : string -> string -> unit
    method add key value = self#assert_write; self#do_add key value


    method private virtual do_find: string -> string
    method find key = self#assert_read; self#do_find key

    method private virtual do_replace: string -> string -> unit
    method replace key value = self#assert_write; self#do_replace key value

    method private virtual do_remove: string -> unit
    method remove key = self#assert_write; self#do_remove key
      
    method private virtual do_iter: (string -> string -> unit) -> unit
    method iter f = self#assert_read; self#do_iter f
  end;;

end;;
