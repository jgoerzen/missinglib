/* arch-tag: ocamlyacc parser for configuration files
*/
%{
  open Lexingutil;;
  open Strutil;;

  let valmerge vallist = 
    let vl2 = List.map Strutil.strip vallist in
    String.concat "\n" vl2;;

%}

%token EOFTOK
%token <string> NEWSECTION NEWSECTION_EOF EXTENSIONLINE
%token <string * string> NEWOPTION
    
%start main
%type <(string * (string * string) list) list> main
%%

main:
  sectionlist { $1 };
  | optionlist sectionlist { ( "DEFAULT", $1 ) :: $2 }
  | optionlist             { [ "DEFAULT", $1 ] }
  | error { raise_syntax_error "ConfigParser" (Parsing.symbol_start_pos () ) }
;

sectionlist:
  EOFTOK { [] }
  | sectionhead EOFTOK { [$1, []] }
  | section sectionlist { $1 :: $2 }
;

section:
  sectionhead optionlist { $1, $2 }
;

sectionhead:
  NEWSECTION { strip $1 }
;

optionlist:
  coption optionlist { $1 :: $2 }
  | coption { [ $1 ] } 
;

extensionlist:
  EXTENSIONLINE extensionlist { $1 :: $2 }
  | EXTENSIONLINE { [ $1 ] }
;

coption:
  NEWOPTION extensionlist { ( strip (fst $1), valmerge ((snd $1) :: $2) ) }
  | NEWOPTION { ( strip (fst $1), strip (snd $1) ) }
;
