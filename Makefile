build:
	cp pkg/META.in pkg/META
	ocaml pkg/pkg.ml build

clean:
	ocaml pkg/pkg.ml clean
	rm -f pkg/META

VERSION := $(shell cat VERSION)
NAME    := systemverilog
ARCHIVE := https://github.com/xguerin/$(NAME)/archive/$(VERSION).tar.gz

overwrite:
	git tag -d $(VERSION) || true
	git push origin :$(VERSION) || true
	git tag -a $(VERSION) -m "Version $(VERSION)"
	git push --tags

release:
	git tag -a $(VERSION) -m "Version $(VERSION)"
	git push --tags

publish:
	opam publish prepare $(NAME).$(VERSION) $(ARCHIVE)
	cp opam $(NAME).$(VERSION)
	cp descr $(NAME).$(VERSION)
	opam publish submit $(NAME).$(VERSION)
	rm -rf $(NAME).$(VERSION)
