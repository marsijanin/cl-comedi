;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;; comedilib cffi wrappers: some more lispish stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :cl-comedi)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-comedi-device-pointer ((pointer device) &body body)
  "Call `%open` on device, bind pointer to the result, execute body inside
   unwind-protect and try to call %close."
  `(let ((,pointer (%open ,device)))
     (unwind-protect
	  (unless (null-pointer-p ,pointer)
	    ,@body)
       (unless (null-pointer-p ,pointer)
	 (%close ,pointer)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-c-struct-wrapper range ())
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-range (device subdevice channel range)
  (make-instance 'range :pointer (%get-range device subdevice channel range)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Some more lispish wrappers around struct comedi_insnlist
(defun setup-instructions-pointer (pointer instructions-keyword &key
                                   (number 1)
                                   data-pointer
                                   (subdev 0)
                                   (chan 0)
                                   (range 0)
                                   (aref-keyword :ground))
  (labels ((cr-pack (channels range aref)
             (logior (ash (logand (foreign-enum-value 'aref aref)  #x03) 24)
                     (ash (logand range #xff) 16)
                     channels)))
    (with-foreign-slots ((instructions n data subdevice channels)
                         pointer instructions)
      (setf instructions instructions-keyword
            n number
            data data-pointer
            subdevice subdev
            channels (cr-pack chan range aref-keyword))
      pointer)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
