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
open Hashtbloper;;
open ConfigParser_interp;;

exception DuplicateSectionError;;
exception InvalidBool of string;;

let process_default default convfunc loadfunc =
  try convfunc(loadfunc ()) with
      Not_found as exc ->
        match default with
            None -> raise exc
          | Some x -> x;;

let def default convfunc getfunc sname oname =
  process_default default convfunc (fun () -> getfunc sname oname);;

class rawConfigParser = 
object(self)
  initializer self#add_section "DEFAULT"
  val configfile = make_file ()
  val getdata = fun obj sname oname -> obj#maingetdata sname oname
  method maingetdata sname oname =
    try
      find (self#section_h sname) (self#optionxform oname)
    with Not_found -> find (self#section_h "DEFAULT") (self#optionxform oname)
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
  method get ?default =
    def default (fun x -> x) (getdata self)
  method getint ?default =
    def default int_of_string (getdata self)
  method getfloat ?default = 
    def default float_of_string (getdata self)
  method private getbool_isyes value =
    List.mem (String.lowercase value) ["1"; "yes"; "true"; "on"; "enabled"]
  method private getbool_isno value =
    List.mem (String.lowercase value) ["0"; "no"; "false"; "off"; "disabled"]
  method private bool_of_string v =
    if self#getbool_isyes v then true else
      if self#getbool_isno v then false else
        raise (InvalidBool v)

  method getbool ?default = 
    def default self#bool_of_string (getdata  self)
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

exception Interpolation_error of string;;

class configParser =
object(self)
  inherit rawConfigParser as super
    (*
  val interp_getdata = 
    fun ?(raw=false) ?(idepth=10) ?extravars obj sname oname ->
      obj#maininterpgetdata raw idepth extravars sname oname
    *)
  method private maininterpgetdata raw idepth extravars sname oname =
    if raw then self#maingetdata sname oname else
      self#getdata_interp idepth false extravars sname oname
  method private getdata_interp idepth usevars extravars sname oname =
    let rec realfunc idepth usevars extravars sname oname = 
      if idepth < 0 then raise (Interpolation_error "Interpolation depth exceeded");
      let data =
        let default = self#maingetdata sname oname in
        match extravars with
          Some x -> if usevars then
            (try find x oname with Not_found -> self#maingetdata sname oname)
          else default
          | None -> self#maingetdata sname oname in
      interpolate_string data (realfunc (idepth - 1) true extravars sname)
    in realfunc idepth usevars extravars sname oname

end;;



