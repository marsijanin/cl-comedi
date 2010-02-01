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
                                   (aref-keyword :aref-ground))
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
(defmacro with-instructions-list ((list-var &rest instructions) &body body)
  "Example:
   (let ((a (make-array 10                                      
                        :element-type '(unsigned-byte 32))))    
     (with-pointer-to-vector-data (p a)                         
       (with-instructions-list (l (:insn-read :data-pointer p))
         (with-comedi-device-pointer (dev \"/dev/comedi0\")       
           (%do-instructions-list dev l)                        
           a))))                                                
   ==> some readed data
  "
  (alexandria:with-gensyms (instructions-array )
    (let ((length (length instructions)))
      `(with-foreign-objects ((,instructions-array 'instructions ,length)
                              (,list-var           'instructions-list))
         ,@(loop
              :for instruction :in    instructions
              :as  offset      :below length
              :as  pointer     :=     `(mem-aref ,instructions-array 
                                                 'instructions ,offset)
              :collect `(setup-instructions-pointer ,pointer ,@instruction))
         (with-foreign-slots ((instructions-number pointer-to-instructions)
                              ,list-var instructions-list)
           (setf instructions-number     ,length 
                 pointer-to-instructions ,instructions-array)
           ,@body)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
