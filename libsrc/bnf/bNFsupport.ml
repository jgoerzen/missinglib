(*pp camlp4o *)
(* arch-tag: BNF support code
Copyright (C) 2004 John Goerzen <jgoerzen@complete.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

open List;;
open Stream;;

class ['a] lazyStream (parentstream: 'a Stream.t) =
object (self)
  val mutable cache = []
  val mutable cstream = parentstream
  val mutable lastconsume = 0

  initializer 
    cstream <- Stream.from self#nth_item

  method nth_item n = 
    let oldlen = length cache in
    if n < oldlen then
      Some (nth cache n)
    else begin
      let newval = npeek (n+1) parentstream in
      if (length newval) != (n+1) then
        None
      else begin
        cache <- newval;
        Some (nth newval n);
      end;
    end;

  method next_item = self#nth_item (length cache)

    
    (*
  method consumeall = 
    let rec thefunc () = match cache with
        [] -> ()
      | x::xs -> junk parentstream; cache <- xs; thefunc()
    in
    thefunc ()

  method reset = cache <- []
    *)

  method consume_stream = 
    let n_to_consume = count cstream - lastconsume in
    let rec consumeit n = match n with
        0 -> ()
      | x -> junk parentstream; cache <- tl cache; consumeit (x -1) in
    consumeit n_to_consume;
    lastconsume <- count cstream;

    (*

  method to_stream = let rec thefunc () = match self#next_item with
      None -> [< >]
    | Some item -> [< 'item; thefunc() >]
  in thefunc ()
    *)
    
  method to_stream = cstream

end;;
