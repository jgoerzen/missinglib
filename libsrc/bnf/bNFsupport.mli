(* arch-tag: BNF support code, interface definition
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

(** {6 Simple Storage of Hashtable-like objects on disk}

This module is a wrapper around the persistent storage features in
{!Hashtblutil}.  It is available on all systems.

For usage examples, please see {!AnyDBM}.
*)

(** BNF Parser support utilities

@author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org>
*)

(** {6 Lazy Streams}

Code to work with non-consuming streams. *)

(** The primary lazy stream class.  It should take an existing stream as a
parameter to [new] when the class is instantiated.

This class can present a stream interface itself via the to_stream call.

Accesses to the stream represented by this class will read -- but not consume -- data
from the stream passed in.  Once the data is ready to be consumed, you may call
consumeall.  This will consume all parent data read since the object was
instantiated or reset. *)
class ['a] lazyStream: 'a Stream.t -> object

  (** Returns the next item available, or None if no more items are available.
  *)
  method next_item: 'a option

  (** Returns the nth item available, starting from 0, or None if no more
      items are available. *)
  method nth_item: int -> 'a option
    (*
  (** Consumes, on the parent stream, all items accessed via this object
    since it was created or reset, then resets this object. *)
  method consumeall: unit

  (** Resets this object, forgetting everything read up to this point. *)
  method reset: unit
    *)

  (** Consumes on the parent stream all items that have been consumed
    by the stream returned by to_stream on this object. *)
  method consume_stream: unit

  (** Returns a stream for this object.  This stream can be used as normal,
    and calls to Stream.next or String.junk on it will 
  *)
  method to_stream: 'a Stream.t
end
