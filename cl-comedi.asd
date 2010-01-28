;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;; comedilib cffi wrappers: asdf system definition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(eval-when (:compile-toplevel :load-toplevel :execute)
  (oos 'load-op :cffi-grovel))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsystem :cl-comedi
  :depends-on (:iolib.syscalls)
  :author "Nikolay V. Razbegaev <marsijanin@gmail.com>"
  :description "Comedilib wrappers."
  :licence "Not decide yet"
  :serial t 
  :components ((:file "pkgdcl")
               (cffi-grovel:grovel-file "ffi-types")
               (:file "ffi-functions")
               (:file "comedi")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
