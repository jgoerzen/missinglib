(** arch-tag: main config parser file
Copyright (C) 2004 John Goerzen
<jgoerzen@complete.org>

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

module Cptypes = ConfigParser_types;;
open Cptypes;;
open Hashtbl;;
open Hashtblutil;;

exception DuplicateSectionError;;
exception InvalidBool of string;;

class rawConfigParser = 
  object(self)
    initializer self#add_section "DEFAULT"
    val configfile = make_file ()
    method sections = List.filter (fun x -> x <> "DEFAULT") (keys configfile)
    method add_section sname = 
      if self#has_section sname then
        raise DuplicateSectionError
      else 
        replace configfile sname (make_section ())
    method has_section sname = mem configfile sname
    method private section_h sname = find configfile sname
    method options sname = keys (self#section_h sname)
    method has_option sname oname = let o = self#optionxform oname in  
      (self#has_section sname) && mem (self#section_h sname) o 
    method readfile filename =
      let ichan = open_in filename in
      self#readchan ichan;
      close_in ichan
    method readchan ichan =
      let ast = ConfigParser_runparser.parse_channel ichan in
      convert_list_file configfile self#optionxform ast 
    method readstring istring =
      let ast = ConfigParser_runparser.parse_string istring in
      convert_list_file configfile self#optionxform ast 
    method get sname oname = 
      try
        find (self#section_h sname) (self#optionxform oname)
      with Not_found -> find (self#section_h "DEFAULT") (self#optionxform oname)
    method getint sname oname = int_of_string (self#get sname oname)
    method getfloat sname oname = float_of_string (self#get sname oname)
    method private getbool_isyes value =
      List.mem (String.lowercase value) ["1"; "yes"; "true"; "on"; "enabled"]
    method private getbool_isno value =
      List.mem (String.lowercase value) ["0"; "no"; "false"; "off"; "disabled"]
    method getbool sname oname = 
      let v = self#get sname oname in
      if self#getbool_isyes v then true else
        if self#getbool_isno v then false else
          raise (InvalidBool v)
    method items sname = items (self#section_h sname)
    method set sname oname value =
      let s = self#section_h sname in
      replace s (self#optionxform oname) value
    method to_string = string_of_file configfile
    method writefile filename = 
      let ochan = open_out filename in
      self#writechan ochan;
      close_out ochan
    method writechan ochan = output_string ochan (self#to_string)
    method remove_option sname oname =
      if self#has_option sname oname then
        (remove (self#section_h sname) (self#optionxform oname); true)
      else false
    method remove_section sname =
      if (sname != "DEFAULT") && self#has_section sname then
        (remove configfile sname; true)
      else false
    method optionxform oname = String.lowercase oname
  end;;
