(* arch-tag: Stream parser interface file *)
(*
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

(** Stream creation, parsing, and manipulation utilities 

@author Copyright (C) 2004 John Goerzen <jgoerzen\@complete.org>
*)

(** {6 Stream generation}

These functions create new streams. *)

(** Given an input file descriptor, generates a stream that yields
each line of the input file. *)
val of_channel_lines: in_channel -> string Stream.t

(** Given an input file descriptor and a blocksize, generates a stream
that yields blocks of the given blocksize.  The very last block in the
stream may have a lower size if the input does not end on an even block
boundary.  All other blocks are guaranteed to match the given block size.
*)
val of_channel_blocks: in_channel -> int -> string Stream.t

(** {6 Stream Conversion Utilities}

These utilities work on streams, returning a new lazy stream that
reflects the changes. *)

(** Given a function, returns a new stream with all the elements of the
original stream for which func returns true. *)
val filter: ('a -> bool) -> 'a Stream.t -> 'a Stream.t

(** Given a function, returns a new stream with the results of func
applied to each element. *)
val map: ('a -> 'b) -> 'a Stream.t -> 'b Stream.t

(** Given a function, returns a new stream with the results of func
applied to each element.

Unlike {!Streamutil.map}, which expects func to take a single element and
return a single element, this function expects func to take a single element
and return a stream.  This is a powerful capability that allows func
to grow or shrink the results of processing the single element. *)
val map_stream: ('a -> 'b Stream.t) -> 'a Stream.t -> 'b Stream.t

(** Given a function and an initial argument, calls the function on
each element in the stream.  Similar to List.fold_left. *)
val fold_left: ('a -> 'b -> 'a) -> 'a -> 'b Stream.t -> 'a

(** Converts a stream to a list.  WARNING: this will crash your program if
used on infinite or very large streams.  Use only on finite streams! *)
val to_list: 'a Stream.t -> 'a list

(** Returns a finite stream representing the first n elements from
the given stream.
 *)
val take: int -> 'a Stream.t -> 'a Stream.t

(** Removes the first n elements from the start of the given stream.   Unlike
operations on lists, this is a destructive operation.
*)
val drop: int -> 'a Stream.t -> unit

(** {6 Stream processing utilities}

These do something with a stream, and generally consume its elements
completely. *)

(** Given a stream of lines (such as created with {!Streamutil.of_channel_lines},
output a line containing each element from the stream.  The input stream
is expected to not have newlines (those will be added automaticaly.) *)
val output_lines: out_channel -> string Stream.t -> unit

(** Given a stream of characters (such as created with
{!Stream.of_channel}), output the characters representing each element from
the stream. *)
val output_chars: out_channel -> char Stream.t -> unit

(** {6 Stream parser utilities}

These functions are used to parse streams. *)

(** This function is useful for parsing zero or more occurances of a certain
    element.

    @param func The parser function.  Will be called repeatedly until
                Stream.Failure is raised.
    @param accum Accumulator -- pass [] to it to start with.
    @param args Passed to func.
    @return A list of return values from func; may be empty.
*)
val optparse: ('a -> 'b) -> 'b list -> 'a -> 'b list

(** Same as optparse, but forces to match at least once.  funchead is applied
    to the first element; functail to all the rest.
    
    @param funchead Function to apply to first element
    @param functail Function to apply to remaining arguments
    @param accum Accumulator -- pass [] to start with
    @param args Passed to the various functions
*)
val optparse_1: ('a -> 'b) -> ('a -> 'b) -> 'b list -> 'a -> 'b list

(** Used to do something that happens once or more, and folds the results.
* Uses optparse_1 internally.
* @param func Parser function
  @param combinefunc Combination function used for folding
  @param startval Starting value for folding
  @param args Parser arguments *)
val optparse_1_folded: ('a -> 'b) -> ('c -> 'b -> 'c) -> 'c -> 'a -> 'c

(** Utility function used to generate strings; equivolent to
*   optparse_1_folded func (^) "" args
*   @param func Parser function
    @param args Arguments *)
val optparse_1_string: ('a -> string) -> 'a -> string

