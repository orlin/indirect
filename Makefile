BIN ?= indirect
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib/indirect

install:
	mkdir -p $(LIBDIR)
	cp indirect* README.md package.json $(LIBDIR)
	ln -fs $(LIBDIR)/indirect $(BINDIR)/$(BIN)

uninstall:
	rm -f $(BINDIR)/$(BIN)
	rm -rf $(LIBDIR)
