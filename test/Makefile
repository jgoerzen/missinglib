# Copyright (C) 2004 John Goerzen
# arch-tag: testing for library Makefile
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

SOURCES = testutil.ml teststrutil.ml testlistutil.ml testhashtblutil.ml \
	  testconfigparser.ml runtests.ml
INCDIRS = ../libsrc $(shell find ../libsrc -type d -maxdepth 1 )
LIBDIRS = ../libsrc
LIBS = str missinglib oUnit
PACKS = oUnit
RESULT = runtests
NCSUFFIX = .opt

PATHTOTOP := ..
-include ../Makefile.setup

all: dc $(NATIVE_CODE_TARGET)
test: all
	./runtests
ifeq ($(HAS_NATIVE),YES)
	./runtests.opt
endif

