(* arch-tag: Unix module utilities
* Copyright (c) 2004 John Goerzen
*)

open Unix;;
open Str;;

let exists fn = try ignore (lstat fn); true with error -> false;;

let list_of_dir dirname =
  let dirh = opendir dirname in
  let rec readit () =
    match (try Some (readdir dirh) with End_of_file -> None) with
      Some "." -> readit ()
    | Some ".." -> readit ()
    | Some x -> x :: readit ()
    | None -> []
  in 
  let result = readit () in
  closedir dirh;
  result;;

let fold_directory func firstval dirname =
  List.fold_left func firstval (list_of_dir dirname);;

let recurse_cmd f startname =
  let rec recurse_cmd_do f startname =
    let info = Unix.lstat startname in
    match info.st_kind with
        S_DIR -> ignore (fold_directory (recurse_cmd_dir f) startname startname);
          f info startname;
      | _ -> f info startname;
  and recurse_cmd_dir f startname curname =
    let thisname = startname ^ "/" ^ curname in
    recurse_cmd_do f thisname;
    startname 
  in
  recurse_cmd_do f startname;;

(* exception RMError of string;; *)
let rm ?(recursive=false) ?(force=false) filename =
  let recunl info name = 
    try
      if info.st_kind = S_DIR then 
        Unix.rmdir name
      else
        Unix.unlink name
    with (Unix.Unix_error _) as exc ->
      if not force then raise exc
  in
  try
    if recursive then
      recurse_cmd recunl filename
    else
      recunl (Unix.lstat filename) filename
  with (Unix.Unix_error _) as exc ->
    if not force then raise exc;;
