(* arch-tag: support for indexed types
Copyright (C) 2004 John Goerzen 
*)
class type ['a, 'b] indexed_t = 
  object 
    method sub : int -> int -> ('a, 'b) indexed_t
    method length : int
    method prepend: 'b -> ('a, 'b) indexed_t
    method extend: 'a -> ('a, 'b) indexed_t
    method get: 'a
    method iter: ('b -> unit) -> unit
    (*
    method map: 'd.  ('b -> 'd) -> (_, _) indexed_t
    *)
    method fold_left: 'd.  ('d -> 'b -> 'd) -> 'd -> 'd 
    method sort: ('b -> 'b -> int) -> ('a, 'b) indexed_t
    method set: 'a -> unit
  end
;;
class virtual ['a, 'b] indexed (init:'a) = 
  object (self: 'c)
    val mutable contents = (init:'a)
    method private copyhelper data = 
      let newobj = Oo.copy self in
      newobj#set data;
      newobj
    method get = contents
    (*
    (* method virtual map: 'd 'e.  ('b -> 'd) -> ('e, 'd) indexed_t *)
    method virtual map: 'd 'e.  ('b -> 'd) -> 'e
    method virtual fold_left: 'd.  ('d -> 'b -> 'd) -> 'd -> 'c
    *)
    method set x = contents <- x  
  end
;;
class ['z] indexedarray (init:'z array) =
  object (self:indexed_t)
    inherit ['z array, 'z] indexed init
    method sub x y = (self#copyhelper (Array.sub contents x y) :> ('z array, 'z)
    indexed_t)
    method length = Array.length contents
    method prepend newitem = (new indexedarray (
      let a = Array.make 1 newitem in
      Array.append a contents) :> ('z array, 'z) indexed_t)
    method extend  = fun newitems -> ((self#copyhelper (Array.append contents
    newitems)) :> ('z array, 'z) indexed_t)
    method iter f = Array.iter f contents
    method map f = (new indexedarray (Array.map f contents) :> ('z array, 'z)
      indexed_t)
    method fold_left f x = (self#copyhelper(Array.fold_left f x contents) 
     :> ('z array, 'z) indexed_t)
    method sort f = (self#copyhelper (
      let newobj = Array.copy contents in Array.sort f newobj; newobj)
      :> ('z array, 'z) indexed_t)
  end
;;
