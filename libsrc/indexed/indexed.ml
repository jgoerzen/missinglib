(* arch-tag: support for indexed types
Copyright (C) 2004 John Goerzen 
*)

class virtual ['b] indexed (init:'a) = 
  object (self: 'c)
    val mutable contents = (init:'a)
    method private copyhelper data = 
      let newobj = Oo.copy self in
      newobj#set data;
      newobj
    method virtual sub : int -> int -> 'c
    method virtual length : int
    method virtual prepend: 'b -> 'c
    method virtual extend: 'a -> 'c
    method get = contents
    method virtual iter: ('b -> unit) -> unit
    method virtual map: 'd 'e.  ('b -> 'd) -> 'd indexed
    method virtual fold_left: 'd.  ('d -> 'b -> 'd) -> 'd -> 'c
    method virtual sort: ('b -> 'b -> int) -> 'c 
    method set x = contents <- x  
  end
;;

class ['b] indexedarray init =
  object (self: 'c)
    inherit ['b] indexed init
    constraint 'a = 'b array
    method sub x y = self#copyhelper (Array.sub contents x y)
    method length = Array.length contents
    method prepend newitem = self#copyhelper (
      let a = Array.make 1 newitem in
      Array.append a contents)
    method extend newitems = self#copyhelper (Array.append contents newitems)
    method iter f = Array.iter f contents
    method map f = new indexedarray (Array.map f contents) 
    (*
    method fold_left f x = self#copyhelper(Array.fold_left f x contents) *)
    method sort f = self#copyhelper (
      let newobj = Array.copy contents in Array.sort f newobj; newobj)
  end
;;
