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

(** {recurse_cmd func name} will call {func stats name} on every entry
  in or beneath name, which may specify a directory or a file.  For entries
  in subdirectires, the full relative path starting from name will be
  passed. *)
val recurse_cmd: (Unix.stats -> string -> unit) -> string -> unit

(** {6 Shell replacements}
These functions replace standard shell functions with the same name.
*)

(** Remove files or directories.

  By default, will remove only a given file and will raise an
  error if it fails to do so.
  
  if ~force is given and is set true, errors are never raised but simply ignored.

  If ~recursive is given and is set true, a directory
  name may be given.  The directory and all entries beneath it will
  be removed.
*)
val rm: ?recursive:bool -> ?force:bool -> string -> unit
