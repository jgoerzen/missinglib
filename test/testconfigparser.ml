(* arch-tag: tests for configparser
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
open ConfigParser;;
open Lexingutil;;
open Testutil;;

let makecp doc =
  let cp = new rawConfigParser in
  cp#readstring doc;
  cp;;

let makeicp doc =
  let cp = new configParser in
  cp#readstring doc;
  cp;;

let test_instantiate () =
  let cp = new rawConfigParser in
  assert_equal ~msg:"no sections" (List.length cp#sections) 0;;

let test_simpleparse (makecp:string -> rawConfigParser) = [
  "empty" >:: (fun () -> let cp = makecp "" in
    assert_equal ~msg:"empty doc, no sections" (List.length cp#sections) 0
    );
   "one empty line" >:: (fun () -> let cp2 = makecp "\n" in
     assert_equal ~msg:"one empty line" (List.length cp2#sections) 0
   );
   "comment line only" >:: (fun () -> let cp3 = makecp "#foo bar" in
     assert_equal ~msg:"comment line only" (List.length cp3#sections) 0 
   );
   "comment line with \\n" >:: (fun () -> let cp4 = makecp "#foo bar\n" in
     assert_equal ~msg:"comment line with \\n" (List.length cp4#sections) 0
   );
   "one empty sect" >:: (fun () -> let cp10 = makecp "[emptysect]" in
      assert_equal ~msg:"one empty sect" cp10#sections ["emptysect"]
   );
   "one empty sect w/comment" >:: (fun () -> 
     let cp11 = makecp "#foo bar\n[emptysect]\n" in
     assert_equal ~msg:"one empty sect with comment" cp11#sections ["emptysect"]
   );
   "assure comments not processed" >:: (fun () ->
    let cp11a = makecp "# [nonexistant]\n[emptysect]\n" in
    slist_equal "assure comments not processed" cp11a#sections ["emptysect"]
   );
   "1 empty s w/comments" >:: (fun () ->
     let cp12 = makecp "#fo\n[Cemptysect]\n#asdf boo\n  \n  # fnonexistantg" in
     assert_equal ~msg:"one empty sect with comments" cp12#sections ["Cemptysect"]
   );
   "1 empty s, comments, EOL" >:: (fun () ->
    let cp13 = makecp "[emptysect]\n# [nonexistant]\n" in
    assert_equal ~msg:"one empty sect, comments, EOL" cp13#sections ["emptysect"]
   );
   "1 sec w/option" >:: (fun () ->
    let cp20 = makecp "[sect1]\nfoo: bar\n" in
    assert_equal ~msg:"one sect, EOL" cp20#sections ["sect1"];
    slist_equal "sect options" ["foo"] (cp20#options "sect1");
    string_equal "sect1/foo" (cp20#get "sect1" "foo") "bar"
   );
   "mult options" >:: (fun () ->
     let cp = makecp "\n#foo\n[sect1]\n\n#iiii \no1: v1\no2:  v2\n o3: v3" in
     sslist_equal "options" ["o1"; "o2"; "o3"] (cp#options "sect1");
     slist_equal "sections" ["sect1"] (cp#sections);
     string_equal "item 2" "v2" (cp#get "sect1" "o2")
   );
   "error input" >:: (fun () ->
     assert_raises (ParsingSyntaxError 
       "ConfigParser: Syntax error in <unknown>, at or before offset 6 (line 2, char 1)")
       (fun () -> let cp = makecp "#foo\nthis is bad data" in ignore cp)
   );
   "parser error" >:: (fun () ->
     assert_raises (ParsingSyntaxError
       "ConfigParser: Syntax error in <unknown>, at or before offset 18 (line 3, char 1)")
       (fun () -> let cp = makecp "[sect1]\n#iiiiii \n  extensionline\n#foo" in
       ignore cp)
   );
   "sectionless option" >:: (fun () ->
     let cp = makecp "v1: o1\n[sect1]\nv2: o2" in 
     string_equal "default" "o1" (cp#get "sect1" "v1");
     string_equal "sect1" "o2" (cp#get "sect1" "v2");
     string_equal "default sect" "o1" (cp#get "DEFAULT" "v1")
   );
];;

let test_extensionlines () = 
  let cp = makecp "[sect1]\nfoo: bar\nbaz: l1\n l2\n   l3\n# c\nquux: asdf" in
  sslist_equal "keys" ["baz"; "foo"; "quux"] (cp#options "sect1");
  string_equal "normal" "bar" (cp#get "sect1" "foo");
  string_equal "extended" "l1\nl2\nl3" (cp#get "sect1" "baz");
  string_equal "followup" "asdf" (cp#get "sect1" "quux");
  string_equal "extensions to string" 
    "[sect1]\nbaz: l1\n    l2\n    l3\nfoo: bar\nquux: asdf\n\n" 
    cp#to_string;;

let test_defaults () =
  let cp = makecp "def: ault\n[sect1]\nfoo: bar\nbaz: quuz\nint: 2\nfloat: 3\nbool: yes" in
  string_equal "default item" "ault" (cp#get "sect1" "def");
  assert_raises Not_found (fun () -> cp#get "sect1" "abc");
  assert_raises Not_found (fun () -> cp#get "sect2" "foo");
  string_equal "default from bad sect" "ault" (cp#get "sect2" "def");
  string_equal "Using default feature" "defval" (cp#get ~default:"defval"
  "sect1" "abc");
  assert_equal ~msg:"default int" 19 (cp#getint ~default:19 "sect2" "nonexistant");
  assert_equal ~msg:"default float" 17.34 (cp#getfloat ~default:17.34 "foo" "bar");
  assert_equal ~msg:"default bool" true (cp#getbool ~default:true "foo" "bar");;

let test_interpolate = [
  "example" >:: (fun () -> let cp = makecp "[DEFAULT]
arch = i386

[builder]
filename = test_%(arch)s.c
dir = /usr/src/%(filename)
percent = 5%%" in
                 string_equal "basic" (cp#get "DEFAULT" "arch") "i386";
                 string_equal "filename" "test_i386.c" 
                   (cp#get "builder" "filename");
                 string_equal "dir" "/usr/src/test_i386.c"
                   (cp#get "builder" "dir");
                 string_equal "percents" (cp#get "builder" "percent") "5%";
                );
];;


let suite = "testconfigparser" >:::
  ["test_instantiate" >:: test_instantiate;
   "test_simpleparse" >::: test_simpleparse makecp;
   "test_simpleparse_interp" >::: test_simpleparse makeicp;
   "test_extensionlines" >:: test_extensionlines; 
   "test_defaults" >:: test_defaults;
   "test_interpolate" >::: test_interpolate;
  ];;

