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

open AnyDBM_Interface;;
open Hashtblutil;;
open Hashtbl;;

class anyDBM_String filename flag mode =
object(self)
  inherit anyDBM_Base filename flag mode

  initializer
    begin
      let openflags = Open_text :: (self#flaglist_of_flag Open_rdonly) in

    if flag.write and flag.create 
    
end;;
    
let opendbm filename flag mode =
  let db = new anyDBM_String filename flag mode in
  (db : anyDBM_String : t);;
