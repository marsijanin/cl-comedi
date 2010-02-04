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
  ((:insn-read "INSN_READ")
   :documentation "read values from an input channel")
  ((:insn-write "INSN_WRITE")
   :documentation "write values to an output channel")
  ((:insn-bits "INSN_BITS")
   :documentation "read/write values on multiple digital I/O channels")
  ((:insn-config "INSN_CONFIG")
   :documentation "configure a subdevice")
  ((:insn-gtod "INSN_GTOD")
   :documentation "read a timestamp, identical to gettimeofday()")
  ((:insn-wait "INSN_WAIT")
   :documentation "wait a specified number of nanoseconds")
  ((:insn-inttrig "INSN_INTTRIG")
   :documentation "Its execution causes an internal triggering event."))
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
  ((:aref-ground "AREF_GROUND")
   :documentation "For inputs/outputs referenced to ground.")
  ((:aref-common "AREF_COMMON")
   :documentation "For a `common` reference (the low inputs
                   of all the channels are tied together, but are isolated
                   from ground).")
  ((:aref-diff "AREF_DIFF")
   :documentation "For differential inputs/outputs.")
  ((:aref-other "AREF_OTHER")
   :documentation "For any reference that does not fit
                   into the above categories."))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cffi manual says what cenum element spec has the same syntax as
;; constantenum i.e. `:optional` &key parameter can be specified. But,
;; if I will replace `constantenum` to the `cenum` in the form below,
;; I will receive an grovel-file syntax error. So I'm using `constantenum`
;; which also givese no warnings unlike `cenum`.
(constantenum (subdevice-type  :define-constants t)
  ((:subd-unused  "COMEDI_SUBD_UNUSED")
   :documentation "unused by driver"
   :optional t)
  ((:subd-ai      "COMEDI_SUBD_AI")
   :documentation "analog input"
   :optional t)
  ((:subd-ao      "COMEDI_SUBD_AO")
   :documentation "analog output"
   :optional t)
  ((:subd-di      "COMEDI_SUBD_DI")
   :documentation "digital input"
   :optional t)
  ((:subd-do      "COMEDI_SUBD_DO")
   :documentation "digital output"
   :optional t)
  ((:subd-dio     "COMEDI_SUBD_DIO")
   :documentation "digital input/output"
   :optional t)
  ((:subd-counter "COMEDI_SUBD_COUNTER")
   :documentation "counter"
   :optional t)
  ((:subd-timer   "COMEDI_SUBD_TIMER")
   :documentation "timer"
   :optional t)
  ((:subd-memory  "COMEDI_SUBD_MEMORY")
   :documentation "memory, EEPROM, DPRAM"
   :optional t)
  ((:subd-calib   "COMEDI_SUBD_CALIB")
   :documentation "calibration DACs"
   :optional t)
  ((:subd-proc    "COMEDI_SUBD_PROC")
   :documentation "processor, DSP"
   :optional t)
  ((:subd-serial  "COMEDI_SUBD_SERIAL")
   :documentation "serial IO"
   :optional t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(constantenum (trigger :define-constants t)
  ;; Command trigger events
  ((:trig-now "TRIG_NOW")
   :documentation "The start_src event occurs start_arg nanoseconds after
                   the comedi_cmd is called. Currently, only start_arg=0
                   is supported.
                   All conversion events in a scan occur simultaneously.")
  ((:trig-follow "TRIG_FOLLOW")
   :documentation "(For an output device.) The start_src event occurs when
                   data is written to the buffer.
                   The `scan_begin` event occurs immediately after
                   a `scan_end` event occurs.")
  ((:trig-ext "TRIG_EXT")
   :documentation "The start event occurs when an external trigger signal
                   occurs; e.g., a rising edge of a digital line.
                   `start_arg` chooses the particular digital line.
                   The `scan_begin` event occurs when an external trigger
                   signal occurs; e.g., a rising edge of a digital line.
                   `scan_begin_arg` chooses the particular digital line.
                   The conversion events occur when an external trigger signal
                   occurs, e.g., a rising edge of a digital line.
                   `conavert_arg` chooses the particular digital line.")
  ((:trig-int "TRIG_INT")
   :documentation "The start event occurs on a Comedi internal signal,
                   which is typically caused by an `INSN_INTTRIG` instruction.")
  ((:trig-timer "TRIG_TIMER")
   :documentation "`scan_begin` events occur periodically.
                   The time between scan_begin events is `convert_arg`
                   nanoseconds.
                   The conversion events occur periodically.
                   The time between convert events is `convert_arg`
                   nanoseconds.")
  ((:trig-count "TRIG_COUNT")
   :documentation "Stop the acquisition after stop_arg scans.")
  ((:trig-none "TRIG_NONE")
   :documentation "Perform continuous acquisition,
                   until stopped using `comedi_cancel()`.")
  ((:trig-time "TRIG_TIME")
   :documentation "Cause an event to occur at a particular tim
                   (This event source is reserved for future use.)")
  ((:trig-other "TRIG_OTHER")
   :documentation "Driver specific event trigger.")
  ;; Command flags (questions signs are not mine --
  ;; I'm just reproducing corresponding parts of the comedi manual)
  ((:trig-rt "TRIG_RT")
   :documentation "Ask the driver to use a hard real-time interrupt handler.")
  ((:TRIG-WAKE-EOS "TRIG_WAKE_EOS")
   :documentation "`EOS` means for `End of Scan`.")
  ((:trig-round-nearest "TRIG_ROUND_NEAREST")
   :documentation "Round to nearest supported timing period, the default.")
 ((:trig-round-down "TRIG_ROUND_DOWN")
  :documentation "Round period down.")
 ((:trig-round-up "TRIG_ROUND_UP")
  :documentation "Round period up.")
 ((:trig-round-up-next "TRIG_ROUND_UP_NEXT")
  :documentation "This one doesn't do anything,
                  and I don't know what it was intended to do...?")
 ((:trig-dither "TRIG_DITHER")
  :documentation "Enable dithering?")
 ((:trig-deglitch "TRIG_DEGLITCH")
  :documentation "Enable deglitching?")
 ((:trig-write "TRIG_WRITE")
  :documentation "Write to bidirectional devices.")
 ((:trig-bogus "TRIG_BOGUS")
  :documentation "Do the motions?")
 ((:trig-config "TRIG_CONFIG")
  :documentation "Perform configuration, not triggering.")
 ;; CMDF_* constants: some of them are used to #define some TRIG_* constants
 ;; values, some not. So I'm define CMDF_* constants as part of the trigger
 ;; constantenum case both are widely used as parameters for struct comedi_cmd
 ((:cmdf-priority "CMDF_PRIORITY") :documentation "Same, as trig-rt")
 ((:cmdf-write    "CMDF_WRITE"))
 ((:cmdf-rawdata  "CMDF_RAWDATA")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cstruct command "comedi_cmd"
  ;; Cffi manuals dos not pay special attention on this, but
  ;; after specifying cenum type instead of integer foreign type
  ;; for foreign slots and function parameters you still can pass
  ;; to this functions integer values as well, as keywords:
  ;; i.e. `(foreign-foo 1)` should work as well ass `(foreign-foo :value1)`
  (subdev                 "subdev"         :type :unsigned-int)
  (flags                  "flags"          :type trigger)
  (start-source           "start_src"      :type trigger)
  (start-argument         "start_arg"      :type :unsigned-int)
  (scannig-begin-source   "scan_begin_src" :type trigger)
  (scannig-begin-argument "scan_begin_arg" :type :unsigned-int)
  (convert-source         "convert_src"    :type trigger)
  (convert-argument       "convert_arg"    :type :unsigned-int)
  (scannig-end-source     "scan_end_src"   :type trigger)
  (scannig-end-argument   "scan_end_arg"   :type :unsigned-int)
  (stop-source            "stop_src"       :type trigger)
  (stop-argument          "stop_arg"       :type :unsigned-int)
  (channels-list          "chanlist"       :type :pointer)
  (channels-list-length   "chanlist_len"   :type :unsigned-int)
  (data                   "data"           :type :pointer) ;lsampl_t *
  (data-length            "data_len"       :type :pointer))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
