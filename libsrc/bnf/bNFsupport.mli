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

class ['a] lazyStream: 'a Stream.t -> object
  method next_item: 'a option
  method consumeall: unit
  method reset: unit
  method to_stream: 'a Stream.t
end
