# Copyright (C) 2004 John Goerzen
# arch-tag: top-level library project Makefile
# <jgoerzen@complete.org>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

SOURCES = compose/compose.mli compose/compose.ml \
	  compose/composeoper.mli compose/composeoper.ml \
	  strutil/strutil.mli strutil/strutil.ml \
	  streamutil/streamutil.mli streamutil/streamutil.ml \
	  hashtblutil/hashtblutil.mli hashtblutil/hashtblutil.ml \
	listutil/listutil.mli listutil/listutil.ml \
	  lexingutil/lexingutil.mli lexingutil/lexingutil.ml \
	  hashtblutil/hashtbloper.mli hashtblutil/hashtbloper.ml \
	  slice/slice.mli slice/slice.ml \
	  slice/sliceoper.mli slice/sliceoper.ml \
	  indexed/indexed.ml \
	  fileutil/fileutil.mli fileutil/fileutil.ml \
	  unixutil/unixutil.mli unixutil/unixutil.ml \
	  configParser/configParser_types.ml \
	  configParser/configParser_parser.mly \
	  configParser/configParser_lexer.mll  \
	  configParser/configParser_runparser.ml \
	  configParser/configParser_interp_lexer.mll \
	  configParser/configParser_interp.ml \
	  configParser/configParser.mli \
	  configParser/configParser.ml \
	  anyDBM/anyDBM_Interface.mli \
	  anyDBM/anyDBM_Interface.ml \
	  anyDBM/anyDBM_String.mli \
	  anyDBM/anyDBM_String.ml


INCLDIRS = -I strutil -I compose -I hashtblutil -I listutil -I lexingutil -I slice \
	   -I anyDBM \
	    -I configParser -I fileutil -I unixutil -I streamutil
	    
OCAMLDOC = ocamldoc -pp camlp4o -stars -sort $(INCLDIRS)
#LIBS = str
RESULT = missinglib
OCAMLYACC := ocamlyacc -v
DOC_FILES := compose/compose.mli compose/compose.ml \
	compose/composeoper.mli compose/composeoper.ml \
	strutil/strutil.mli strutil/strutil.ml \
	streamutil/streamutil.mli streamutil/streamutil.ml \
	hashtblutil/hashtblutil.mli hashtblutil/hashtblutil.ml \
	hashtblutil/hashtbloper.mli hashtblutil/hashtbloper.ml \
	listutil/listutil.mli listutil/listutil.ml \
	lexingutil/lexingutil.mli lexingutil/lexingutil.ml \
	fileutil/fileutil.mli fileutil/fileutil.ml \
	unixutil/unixutil.mli unixutil/unixutil.ml \
	slice/slice.mli slice/slice.ml \
	slice/sliceoper.mli slice/sliceoper.ml \
	configParser/configParser.mli \
	anyDBM/anyDBM_Interface.mli \
	anyDBM/anyDBM_Interface.ml \
	anyDBM/anyDBM_String.mli \
	anyDBM/anyDBM_String.ml

MLIFILES := $(filter %.mli,$(SOURCES))
LIBINSTALL_FILES := META $(MLIFILES) $(patsubst %.mli,%.cmi,$(MLIFILES)) $(RESULT).cma $(RESULT).a
PATHTOTOP := ..

-include ../Makefile.setup
ifeq ($(HAS_NATIVE),YES)
  LIBINSTALL_FILES := $(LIBINSTALL_FILES) $(RESULT).cmxa
endif

interact: all
	ocaml $(INCLDIRS) unix.cma str.cma missinglib.cma

all: bcl $(NATIVE_LIB_TARGET)
