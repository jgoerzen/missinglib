# arch-tag: Top-level recursive Makefile
#
SUBDIRS := libsrc test

defaulttgt:
	$(MAKE) all

interact: defaulttgt
	cd libsrc && $(MAKE) interact

printenv:
	@$(MAKE) -f Makefile.setup printenv PATHTOTOP=.

install:
	$(MAKE) -C libsrc libinstall

test: defaulttgt
	$(MAKE) -C test test

distclean: clean
	-rm `find . -name "*~"`
	-rm -r libsrc/doc libsrc/ocamldoc.* libsrc/configParser/*.output
	-find . -name "*.cmo" -exec rm {} \;
	-find . -name "*.cmi" -exec rm {} \;
%:
	for DIR in $(SUBDIRS); do make -C $$DIR $@ || exit 1; done
