(* arch-tag: unix utilities interface file
Copyright (c) 2004 John Goerzen *)

(** Unix utilities.

This module provides various helpful utilities for use with the built-in
Unix module.
@author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org>
*)

(** {6 File functions}
These functions help process files
*)

(** Returns true if the specified file exists; false otherwise. *)
val exists: string -> bool

(** {6 Directory processing}
These functions help process directories.
*)

(** Returns a list of all entries, exclusive of "." and "..", in the
specified directory. *)
val list_of_dir: string -> string list

(** Folds over the specified directory *)
val fold_directory: ('a -> string -> 'a) -> 'a -> string -> 'a
