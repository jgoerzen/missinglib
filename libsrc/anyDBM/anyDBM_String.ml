(* arch-tag: AnyDBM module for on-disk string tables
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

open AnyDBM;;
open AnyDBMUtils;;
open Hashtbl;;
open Hashtblutil;;

class dbm filename flag mode =
object(self)
  inherit AnyDBMUtils.anyDBM_Base flag
  val mainhash = begin
    if flag.read then begin
      let openflags = Open_text :: (flags_new_to_open flag Open_rdonly) in
      let fd = open_in_gen openflags mode filename in
      let hash = ichan_to_strhash fd in
      close_in fd;
      hash
    end else 
      create 5
  end

  method private do_close =
    if flag.write then begin
      let openflags = Open_text :: (flags_new_to_open flag Open_wronly) in
      let fd = open_out_gen openflags mode filename in
      strhash_to_ochan mainhash fd;
      close_out fd
    end


  method private do_add key value = 
    if mem mainhash key then
      raise (Dbm_error "Entry already exists")
    else
      add mainhash key value

  method private do_find key =
    find mainhash key

  method private do_replace key value =
    replace mainhash key value

  method private do_remove key =
    remove mainhash key

  method private do_iter func =
    iter func mainhash
      
end;;
    
let opendbm filename flag mode =
  new dbm filename (flags_old_to_new flag) mode;;

