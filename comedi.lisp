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
