;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;; comedilib cffi wrappers. 
;; swig output is total and writing wrappers manually gives you more control
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :cl-comedi)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(eval-when (:compile-toplevel :load-toplevel :execute)
  (define-foreign-library :libcomedi
    #+linux(cffi-features:unix (:or "libcomedi.so" "libcomedi.so.0.8.1"))
    #-linux(error "Comedi work only on under linux"))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (use-foreign-library :libcomedi))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%open "comedi_open") :pointer
  (device :string))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%close "comedi_close") :int
    (device :pointer))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%data-read "comedi_data_read") :int
  (device    :pointer)                  ;comedi_t *
  (subdevice :unsigned-int)
  (channel   :unsigned-int)
  (range     :unsigned-int)
  (aref      :unsigned-int)
  (data      :pointer))                 ;lsampl_t *
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%get-maxdata "comedi_get_maxdata") lsampl-t
  (device    :pointer)                  ;comedi_t *
  (subdevice :unsigned-int)
  (channel   :unsigned-int))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%get-range "comedi_get_range") :pointer
  (device    :pointer)                  ;comedi_t *
  (subdevice :unsigned-int)
  (channel   :unsigned-int)
  (range     :unsigned-int))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defcfun* (%to-phys "comedi_to_phys") :double
  (data    lsampl-t)
  (range   :pointer)                    ;comedi_range *
  (maxdata lsampl-t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defcfun* (%from-phys "comedi_from_phys") lsampl-t
  (data    :double)
  (range   :pointer)                    ;comedi_range *
  (maxdata lsampl-t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
