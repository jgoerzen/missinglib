(* arch-tag: file utilities interface file
Copyright (c) 2004 John Goerzen *)

(** File-related utilities.

This module provides various helpful utilities for deailing with files.
@author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org>
*)

(** {6 File name utilities}
These functions work on file names.
*)

(** {[abspath filename]} returns the absolute path of filename.
  If startdir is given, it is used instead of the current working directory
  to work out relative paths.

  This function works algorithmically, rather than via changing directories,
  and as such does not resolve symlinks or die if bad paths are given.
*)
val abspath: ?startdir:string -> string -> string

(** {6 File reading}
These functions help read data file files.
*)

(** Opens file given, reads the first line, closes the file, and returns
that line. *)
val getfirstline: string -> string

(** Opens file given, reads all lines, closes the file, and returns
a list of those lines. *)
val getlines: string -> string list
