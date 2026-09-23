;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "lsp-julia" "20230915.654"
  "Julia support for lsp-mode."
  '((emacs      "25.1")
    (lsp-mode   "6.3")
    (julia-mode "0.3"))
  :url "https://github.com/gdkrmr/lsp-julia"
  :commit "c869b2f6c05a97e5495ed3cc6710a33b4faf41a2"
  :revdesc "c869b2f6c05a"
  :keywords '("languages" "tools")
  :authors '(("Martin Wolke" . "vibhavp@gmail.com")
             ("Adam Beckmeyer" . "adam_git@thebeckmeyers.xyz")
             ("Guido Kraemer" . "gdkrmr@users.noreply.github.com"))
  :maintainers '(("Guido Kraemer" . "gdkrmr@users.noreply.github.com")))
