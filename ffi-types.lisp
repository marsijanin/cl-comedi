;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;; comedilib cffi wrappers: C types grovel file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :cl-comedi)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#+linux(include "comedilib.h")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ctype lsampl-t "lsampl_t")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cstruct range "comedi_range"
  (min  "min"  :type :double)
  (max  "max"  :type :double)
  (unit "unit" :type :unsigned-int))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(constantenum (instructions-types :define-constants t)
  ((:read "INSN_READ")
   :documentation "read values from an input channel")
  ((:write "INSN_WRITE")
   :documentation "write values to an output channel")
  ((:bits "INSN_BITS")
   :documentation "read/write values on multiple digital I/O channels")
  ((:config "INSN_CONFIG")
   :documentation "configure a subdevice")
  ((:gtod "INSN_GTOD")
   :documentation "read a timestamp, identical to gettimeofday()")
  ((:wait "INSN_WAIT")
   :documentation "wait a specified number of nanoseconds"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cstruct instructions "comedi_insn"
  (instructions "insn"     :type instructions-types)
  (n            "n"        :type :unsigned-int)
  (data         "data"     :type :pointer) ;lsampl_t *
  (subdevice    "subdev"   :type :unsigned-int)
  (channels     "chanspec" :type :unsigned-int)
  (unused       "unused"   :type :pointer))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cstruct instructions-list "comedi_insnlist"
  (instructions-number     "n_insns" :type :unsigned-int)
  (pointer-to-instructions "insns"   :type :pointer)) ;comedi_insn  *
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(constantenum (aref :define-constants t)
  ((:ground "AREF_GROUND")
   :documentation "For inputs/outputs referenced to ground.")
  ((:common "AREF_COMMON")
   :documentation "For a `common` reference (the low inputs
                   of all the channels are tied together, but are isolated
                   from ground).")
  ((:diff "AREF_DIFF")
   :documentation "For differential inputs/outputs.")
  ((:other "AREF_OTHER")
   :documentation "For any reference that does not fit
                   into the above categories."))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
