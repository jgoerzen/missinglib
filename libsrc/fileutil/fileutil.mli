(* arch-tag: file utilities interface file
Copyright (c) 2004 John Goerzen *)

(** File-related utilities.

This module provides various helpful utilities for deailing with files.
@author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org>
*)

(** {6 File reading}
These functions help read data file files.
*)

(** Opens file given, reads the first line, closes the file, and returns
that line. *)
val getfirstline: string -> string

(** Opens file given, reads all lines, closes the file, and returns
a list of those lines. *)
val getlines: string -> string list
