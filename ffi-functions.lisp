;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;; comedilib cffi wrappers. 
;; swig output is total mess and writing wrappers manually gives
;; you more control
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
;; TODO: define-foreign-type (define-c-struct-wrapper or defclass)
;; in order to hide direct pointer manipulation by wrapping it
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
(defsyscall (%get-n-ranges "comedi_get_n_ranges") :int
  (device    :pointer)                  ;comedi_t *
  (subdevice :unsigned-int)
  (channel   :unsigned-int))
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
(defsyscall (%do-instructions-list "comedi_do_insnlist") :int
  (device :pointer)                     ;comedi_t *
  (list   :pointer))                    ;comedi_insnlist *
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall  (%command "comedi_command") :int
  (device  :pointer)                    ;comedi_t *
  (command :pointer))                   ;comedi_cmd *
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%find-subdevice-by-type "comedi_find_subdevice_by_type") :int
  (device          :pointer)            ;comedi_t *
  (type            subdevice-type)
  (start-subdevice :unsigned-int))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%test-command "comedi_command_test") :int
  (device  :pointer)                       ;comedi_t *
  (command :pointer))                      ;comedi_cmd *
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsyscall (%fileno "comedi_fileno") :int
  (device :pointer))                    ;comedi_t *
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
