(lang dune 3.15)

(name dwmstatus)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license "GPL-3.0-only")

(documentation https://url/to/documentation)

(package
 (name dwmstatus)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune x11)
 (tags
  (topics "to describe" your project)))
; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
