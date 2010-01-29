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
(cstruct command "comedi_cmd"
  (subdev                 "subdev"         :type :unsigned-int)
  (flags                  "flags"          :type :unsigned-int)
  (start-source           "start_src"      :type :unsigned-int)
  (start-argument         "start_arg"      :type :unsigned-int)
  (scannig-begin-source   "scan_begin_src" :type :unsigned-int)
  (scannig-begin-argument "scan_begin_arg" :type :unsigned-int)
  (convert-source         "convert_src"    :type :unsigned-int)
  (convert-argument       "convert_arg"    :type :unsigned-int)
  (scannig-end-source     "scan_end_src"   :type :unsigned-int)
  (scannig-end-argument   "scan_end_arg"   :type :unsigned-int)
  (stop-source            "stop_src"       :type :unsigned-int)
  (stop-argument          "stop_arg"       :type :unsigned-int)
  (channels-list          "chanlist"       :type :pointer)
  (channels-list-length   "chanlist_len"   :type :unsigned-int)
  (data                   "data"           :type :pointer) ;lsampl_t *
  (data-length            "data_len"       :type :pointer))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cffi manual says what cenum element spec has the same syntax as
;; constantenum i.e. `:optional` &key parameter can be specified. But,
;; if I will replace `constantenum` to the `cenum` in the form below,
;; I will receive an grovel-file syntax error. So I'm using `constantenum`
;; which also givese no warnings unlike `cenum`.
(constantenum (subdevice-type :define-constants t)
  ((:unused  "COMEDI_SUBD_UNUSED")
   :documentation "unused by driver"
   :optional t)
  ((:ai      "COMEDI_SUBD_AI")
   :documentation "analog input"
   :optional t)
  ((:ao      "COMEDI_SUBD_AO")
   :documentation "analog output"
   :optional t)
  ((:di      "COMEDI_SUBD_DI")
   :documentation "digital input"
   :optional t)
  ((:do      "COMEDI_SUBD_DO")
   :documentation "digital output"
   :optional t)
  ((:dio     "COMEDI_SUBD_DIO")
   :documentation "digital input/output"
   :optional t)
  ((:counter "COMEDI_SUBD_COUNTER")
   :documentation "counter"
   :optional t)
  ((:timer   "COMEDI_SUBD_TIMER")
   :documentation "timer"
   :optional t)
  ((:memory  "COMEDI_SUBD_MEMORY")
   :documentation "memory, EEPROM, DPRAM"
   :optional t)
  ((:calib   "COMEDI_SUBD_CALIB")
   :documentation "calibration DACs"
   :optional t)
  ((:proc    "COMEDI_SUBD_PROC")
   :documentation "processor, DSP"
   :optional t)
  ((:serial  "COMEDI_SUBD_SERIAL")
   :documentation "serial IO"
   :optional t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
