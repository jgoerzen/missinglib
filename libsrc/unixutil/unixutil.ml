(*pp camlp4o *)
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

let rec recurse_stream startname = 
  let info = Unix.lstat startname in
  match info.st_kind with
      S_DIR -> [< (Streamutil.map_stream (fun entry -> 
                                    recurse_stream (startname ^ "/" ^ entry))
                    (Stream.of_list (list_of_dir startname)));
                  '(startname, info) >]
    | _ -> [< '(startname, info) >]
;;
               
let recurse_cmd f startname = Stream.iter f (recurse_stream startname);;

let recurse_list startname = Streamutil.to_list (recurse_stream startname);;

(*
let recurse_cmd_old f startname =
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
*)

(* exception RMError of string;; *)
let rm ?(recursive=false) ?(force=false) filename =
  let recunl (name, info) = 
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
      recunl (filename, Unix.lstat filename)
  with (Unix.Unix_error _) as exc ->
    if not force then raise exc;;

let isdir name =
  try (stat name).st_kind = S_DIR with error -> false;;

let abspath name =
  if not (Filename.is_relative name) then
    name
  else begin
    let startdir = os.getcwd() in
    if isdir name then begin
      os.chdir name;
      let retval = os.getcwd () in
      os.chdir startdir;
      retval;
    end else begin
      let base = Filename.basename name in
      let dirn = Filename.dirname name in
      os.chdir dirn;
      let reval = Filename.concat (os.getcwd()) base in
      os.chdir startdir;
      retval;
    end;
  end;;

