BIN ?= indirect
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib/indirect

install:
	rm -rf $(LIBDIR)
	mkdir -p $(LIBDIR)
	cp indirect* README.md package.json $(LIBDIR)
	ln -fs $(LIBDIR)/indirect.sh $(BINDIR)/$(BIN)

uninstall:
	rm -f $(BINDIR)/$(BIN)
	rm -rf $(LIBDIR)
