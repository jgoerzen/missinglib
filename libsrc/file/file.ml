(* arch-tag: basic file abstraction
* Copyright (c) 2004 John Goerzen
*)

let seek_command = Unix.seek_command;;

class type ['a] file = 
  object (self)
    method read: int64 -> 'a
    method write: 'a -> int64
    method writeall: 'a -> unit
    method seek: int64 -> seek_command -> int64
    method tell: int64
    method truncate: int64 -> unit
    method readline: 'a
    method readlines: 'a list
    method iterlines: ('a -> unit) -> unit
    method fold_left: 'b. ('b -> 'a -> 'b) -> 'b -> 'b
    

