(lang dune 2.5)

(name systemverilog)
(version 0.0.2)

(formatting disabled)
(using menhir 2.0)

(generate_opam_files true)

(source (github xguerin/ocaml-systemverilog))
(license ISC)
(authors "Xavier R. Guérin")
(maintainers "Xavier R. Guérin <github@applepine.org>")

(package
 (name systemverilog)
 (synopsis "SystemVerilog for OCaml")
 (depends
  (dune (>= 2.5))
  (menhir (and :build (>= 20170418)))
))
