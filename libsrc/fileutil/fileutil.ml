(* arch-tag: file utilities
Copyright (c) 2004 John Goerzen *)

let getfirstline filename =
  let fd = open_in filename in
  let line = input_line fd in
  close_in fd;
  line;;

let getlines filename =
  let fd = open_in filename in
  let retval = ref [] in
  begin
    try
      while true do
        retval := (input_line fd) :: !retval
      done
    with End_of_file -> ();
  end;
  close_in fd;
  !retval;
;;

let abspath ?startdir filename =
(*  if not (Filename.is_relative filename) then
    filename
  else *)
  let s = match startdir with
      None -> Sys.getcwd ()
    | Some x -> x in
  if String.length filename < 1 then
    s
  else
    let rec proclist l =
      print_endline ("proclist " ^ (Strutil.join "/" l));
      match l with 
          [] -> []
        | "" :: xs -> proclist xs
        | "." :: xs -> proclist xs
        | ".." :: ".." :: xs -> ".." :: ".." :: proclist xs
        | x :: ".." :: xs -> proclist xs
(*        | ".." :: xs -> raise (Failure "proclist: .. at bad place") *)
        | x :: xs -> x :: proclist xs
    in
    let rec modlist l =
      print_endline ("modlist " ^ (Strutil.join "/" l));
      let pl = proclist l in
      if pl = l then l else modlist pl
    in
    let components = 
      (if String.sub filename 0 1 = "/" then [] else (Strutil.split "/" s)) @
      Strutil.split "/" filename in
    "/" ^ (Strutil.join "/" (modlist components));;

  
  
