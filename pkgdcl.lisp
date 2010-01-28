;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;; comedilib cffi wrappers: package definition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :common-lisp-user)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defpackage #:cl-comedi
  (:nicknames #:comedi)
  (:use :common-lisp :cffi :iolib.syscalls)
  (:export 
   ;; C types and constants:
   #:lsample-t
   #:aref-ground
   #:range
   #:instructions
   #:command
   ;; C functions wrapers:
   #:%open
   #:%close
   #:%data-read
   #:%get-maxdata
   #:%get-range
   #:%get-n-ranges
   #:%to-phys
   #:%from-phys
   #:%do-instructions-list
   ;; Some more lispish stuff:
   #:with-comedi-device-pointer
   #:get-range
   #:with-instructions-list))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
