(* arch-tag: support for indexed types
*)

class virtual ['a, 'b] indexed (init:'a) = 
  object (self: 'c)
    val mutable contents = init 
    method private copyhelper data = 
      let newobj = Oo.copy self in
      newobj#set data;
      newobj
    method virtual sub : int -> int -> 'c
    (*
    method virtual length : int
    method virtual prepend: 'b -> 'c
    method virtual extend: 'a -> 'c
    method get = contents
    method virtual iter: ('b -> unit) -> unit
    method virtual map: 'd.  ('b -> 'd) -> 'c
    method virtual fold_left: 'd.  ('d -> 'b -> 'd) -> 'd -> 'c
    method virtual sort: ('b -> 'b -> int) -> 'c *)
    method set x = contents <- x  
  end
;;

(*
class type ['a, 'b] indexedarray_t = 
  object inherit ['a array, 'a] indexed end;; *)

class ['a, 'b] indexedarray init =
  object (self: 'c)
    inherit ['a array, 'a] indexed init
    method sub x y = self#copyhelper (Array.sub contents x y)
  end
;;
