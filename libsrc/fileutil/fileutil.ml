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

