(* arch-tag: main config parser, interface *)
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

(** System for parsing configuration files *)

(** {1 Introduction}

Many programs need configuration files.  These configuration files are
typically used to configure certain runtime behaviors that need to be saved
across sessions.  Various different configuration file formats exist.

The ConfigParser module attempts to define a standard format that is easy for
the user to edit, easy for the programmer to work with, yet remains powerful and
flexible.

If you are impatient, the primary reference for the API can be found in
{!ConfigParser.rawConfigParser}.

{5 Features}

For the programmer, this module provides:

- Simple calls to both read {b and write} configuration files
- Call that can generate a string version of a file that is re-parsable
by this module (useful for, for instance, sending the file down a network)
- Easy to use calls that can supply default values for missing options
- Segmented configuration files that let you separate configuration into
distinct sections, each with its own namespace.  This can be used to configure
multiple modules in one file, to configure multiple instances of a single
object, etc.
- On-the-fly parsing of integer, boolean, float, and multi-line string values
- It is possible to make a configuration file parsable by this module, the
Unix shell, and/or Unix make, though some feautres are, of course, not
compatible with these other tools.
- Syntax checking with error reporting including line numbers
- Implemented in pure OCaml (with ocamllex/yacc); has no dependencies on modules
outside the standard library or Missinglib.
- Comprehensive documentation
- Object-oriented API to permit easy extensions of functionality

For the user, this module provides:

- Easily human-editable configuration files with a clear, concise, and consistent format
- Configuration file format consistent with other familiar formats
- No need to understand semantics of markup languages like XML

{5 History}

This module is based on Python's
{{:http://www.python.org/doc/current/lib/module-ConfigParser.html}ConfigParser}
module.  While the API of these two modules remains similar, and the aim is to
preserve all useful features of Python's module, there are some differences in
implementation details.  This module is a complete clean re-implementation in
OCaml, not an OCaml translation of a Python program, and as such has certain
features that were not easily accomplished in Python -- and lacks certain
features that are not easily accomplished in OCaml.

{1 Configuration File Format}

The basic configuration file format resembles that of an old-style Windows .INI
file.  Here are two samples: {[
debug = yes
inputfile = /etc/passwd
names = Peter, Paul, Mary, George, Abrahaham, John, Bill, Gerald, Richard,
        Franklin, Woodrow
color = red ]}

This defines a file without any explicit section, so all items will occur within
the default section [DEFAULT].  The [debug] option can be read as a boolean or a
string.  The remaining items can be read as a string only.  The [names] entry
spans two lines -- any line starting with whitespace, and containing something
other than whitespace or comments, is taken as a continuation of the previous
line.


Here's another example: {[
# Default options
[DEFAULT]
hostname: localhost ]}
{[
# Options for the first file
[file1]
location: /usr/local
user: Fred
uid: 1000
optionaltext: Hello, this  entire string is included ]}
{[
[file2]
location: /opt
user: Fred
uid: 1001 ]}

This file defines three sections.  The [DEFAULT] section specifies an entry
[hostname].  If you attempt to read the [hostname] option in any section, and
that section doesn't define [hostname], you will get the value from [DEFAULT]
instead.  This is a nice time-saver.  You can also note that you can use colons
instead of the = character to separate option names from option entries.

{5 Whitespace}

Whitespace (spaces, tabs, etc) is automatically stripped from the beginning and
end of all strings.  Thus, users can insert whitespace before/after the colon
or equal sign if they like, and it will be automatically stripped.

Blank lines or lines consisting solely of whitespace are ignored.

{5 Comments}

Comments are introduced with the pound sign [#] or the semicolon [;].  They
cause the parser to ignore everything from that character to the end of the
line.

Comments {b may not} occur within the definitions of options; that is, you may
not place a comment in the middle of a line such as [user: Fred].  That is
because the parser considers the comment characters part of the string;
otherwise, you'd be unable to use those characters in your strings.  You can,
however, "comment out" options by putting the comment character at the start of
the line.

{5 Case-sensitivity}

By default, section names are case-sensitive but option names are not.  The
latter can be adjusted by subclassing the parser class and overriding
optionxform. *)

(** {1 Exceptions} *)

(** Raised when you attempt to call
{!ConfigParser.rawConfigParser.add_section} when the section already exists *)
exception DuplicateSectionError

(** Raised when you attempt to parse a boolean that is not valid *)
exception InvalidBool of string

(** {1 Classes} *)

(** Primary interface class for configuarion files.

Usage example: {[
  let cp = new rawConfigParser in
  cp#readfile "app.conf";
  print_endline cp#get "sect1" "opt1";
  let calc = (cp#getint "sect1" "intopt1") + (cp#getint "sect1" "intopt2")
  ]}
*)
class rawConfigParser :
  object

    method maingetdata: string -> string -> string

    (** Returns a list of the sections in your configuration file.  Never
    * includes the always-present section [DEFAULT]. *) 
    method sections: string list

    (** Adds a new empty section.  Raises {!ConfigParser.DuplicateSectionError}
     * if the section already exists.  [cp#add_section "foo"] will add the
     * section named "foo" to the object [cp].*)
    method add_section: string -> unit

    (** Find out whether the given section exists.  [cp#has_section "foo"] will
    * return true if that section is present. *)
    method has_section: string -> bool

    (** Returns a list of the names of all the options present in the given
    * section. *)
    method options: string -> string list

    (** Lets you determine whether a given options is present.  Example:
    * [cp#has_option "sectname" "optname"]. *)
    method has_option: string -> string -> bool

    (** Parses the file with the name given and adds its contents to this
    * parser object.  If any options are duplicated, the options in the file
    * override the existing options. *)
    method readfile: string -> unit

    (** Parses the input channel given and adds its contents to the object
      * in the same manner as readfile. *)
    method readchan: in_channel -> unit

    (** Parses the given string and adds its contents to the object in the same
    * manner as readfile. *)
    method readstring: string -> unit

    (** Returns the content of the requested option as a string.  Example:
      * [cp#get "sectname" "optname"].  If [optname] cannot be found in the
      * given section [sectname], searches for that option name in the section
      * [DEFAULT].  If it is still not found there and the optional
      * default argument is given, return that; otherwise, raises [Not_found]. 
      * The other get* functions share this behavior. *)
    method get: ?default:string -> string -> string -> string

    (** Returns the content of the requestied option as an int. *)
    method getint: ?default:int -> string -> string -> int

    (** Returns the content of the requested option as a float. *)
    method getfloat: ?default:float -> string -> string -> float

    (** Returns the content of the requested option as a bool. *)
    method getbool: ?default:bool -> string -> string -> bool

    (** Returns a list of (optionname, value) pairs representing the content of
    * the given section. *)
    method items: string -> (string * string) list

    (** Sets the option to a new value, replacing an existing one if it exists.
    * Example: [cp#set "sectname" "optname" "newvalue"] *)
    method set: string -> string -> string -> unit

    (** Returns a string that could be later parsed back into the content
    * represented by this object. *)
    method to_string: string

    (** Writes the content of the object out to the given filename. *)
    method writefile: string -> unit

    (** Writes the content of the object to the given output channel. *)
    method writechan: out_channel -> unit

    (** Removes the given option.  Returns true if something was removed; false
    * otherwise. Example: [cp#remove_option "sectname" "optname"] *)
    method remove_option: string -> string -> bool

    (** Removes the entire given section.  Cannot be used to remove the
    * [DEFAULT] section.  Returns true if something was removed; false
    * otherwise. *)
    method remove_section: string -> bool

    (** Used to convert an option string to a standardized format.  This is
    * intended to be overridden in subclasses.  Note that the implementation
    * must return the same value each time it is called, and calling it with an
    * already-converted value must return that same value.  The default
    * implementation is [method optionxform oname = String.lowercase oname].*)
    method optionxform: string -> string
  end


class configParser :
  object
    inherit rawConfigParser

    method get: ?default:string -> ?raw:bool -> ?idepth:int -> 
      ?extravars:(string, string) Hashtbl.t 
           -> string -> string -> string
  end
      
