;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(map! :nvime "C-." #'lsp-execute-code-action)

(map! :leader "A" #'org-agenda-list)
