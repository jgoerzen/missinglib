(* arch-tag: tests for fileutil
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

open OUnit;;
open Testutil;;
open Fileutil;;

let test_abspath () =
  mapassert_equal_str "abspath" (fun x -> print_endline x; abspath ~startdir:"/usr/share/doc/m/html" x)
    ["index.html", "/usr/share/doc/m/html/index.html";
     ".", "/usr/share/doc/m/html";
     "..", "/usr/share/doc/m";
     "../README", "/usr/share/doc/m/README";
     "/tmp", "/tmp";
     "/tmp/foo/..", "/tmp";
     "././", "/usr/share/doc/m/html";
     ".././..", "/usr/share/doc";
     ".././../", "/usr/share/doc";
     "../../foo/html/../README", "/usr/share/doc/foo/README";
     "img/foo.gif", "/usr/share/doc/m/html/img/foo.gif";
     "img/dir/", "/usr/share/doc/m/html/img/dir";
     "img/dir/../foo.gif", "/usr/share/doc/m/html/img/foo.gif";
     "./img/dir/.././foo.gif", "/usr/share/doc/m/html/img/foo.gif";
     "../../../../..", "/";
(*     "../../../../../", "/";
     "../../../../../.", "/";
     "../../../../.././", "/";
     "../../../..", "/usr" *)];;

let suite = "testfileutil" >:::
              ["abspath" >:: test_abspath];;


