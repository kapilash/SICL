(cl:in-package #:sicl-register-allocation)

(defun find-register-in-arrangement (arrangement datum)
  ;; Any datum that is not a lexical location does not need to be
  ;; replaced.
  (unless (typep datum 'cleavir-ir:lexical-location)
    (return-from find-register-in-arrangement datum))
  (multiple-value-bind (stack-slot register-number)
      (arr:find-attribution arrangement datum)
    (cond
      ((not (null register-number))
       (aref *registers* register-number))
      ;; Try to make a useful error...
      ((not (null stack-slot))
       (error "~S has an attributed stack slot but no attributed register.
Did you forget to call ENSURE-INPUT-AVAILABLE?"
              datum))
      (t
       (error "~S has no attribution." datum)))))

;; For what it's worth, we should put the 8 bytes-per-word number
;; somewhere in my opinion.
(defconstant +stack-slot-size+ 8)

;; A set of instructions which were generated as part of introducing
;; registers, and thus should not be processed.
(defvar *generated-instructions* (make-hash-table))

(defun mark-as-generated (instruction)
  (setf (gethash instruction *generated-instructions*) t)
  instruction)

(defun instruction-generated-p (instruction)
  (values
   (gethash instruction *generated-instructions* nil)))

(defun save-to-stack-instruction (from-register to-stack-slot)
  (mark-as-generated
   (make-instance 'cleavir-ir:memset2-instruction
     :inputs (list *rsp*
                   (make-instance 'cleavir-ir:immediate-input
                                  :value (* to-stack-slot +stack-slot-size+))
                   (aref *registers* from-register)))))

(defun load-from-stack-instruction (from-stack-slot to-register)
  (mark-as-generated
   (make-instance 'cleavir-ir:memref2-instruction
     :inputs (list *rsp*
                   (make-instance 'cleavir-ir:immediate-input
                                  :value (* from-stack-slot +stack-slot-size+)))
     :outputs (list (aref *registers* to-register)))))

(defun replace-instruction (instruction new-instruction)
  (cleavir-ir:insert-instruction-after new-instruction instruction)
  (cleavir-ir:delete-instruction instruction)
  new-instruction)

(defgeneric introduce-registers-for-instruction (instruction))

;;; Skip instructions which were generated by processing previous instructions.
(defmethod introduce-registers-for-instruction :around (instruction)
  (unless (instruction-generated-p instruction)
    (call-next-method)))

;;; For most instructions, it suffices to replace every lexical
;;; location with the registers attributed to them.
(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:instruction))
  (let ((input-arrangement (input-arrangement instruction)))
      (setf (cleavir-ir:inputs instruction)
            (mapcar (lambda (input)
                      (find-register-in-arrangement input-arrangement
                                                    input))
                    (cleavir-ir:inputs instruction))))
  (let ((output-arrangement (output-arrangement instruction)))
    (setf (cleavir-ir:outputs instruction)
          (mapcar (lambda (output)
                    (find-register-in-arrangement output-arrangement
                                                  output))
                  (cleavir-ir:outputs instruction)))))

;;; An ENTER-INSTRUCTION only has outputs, and only the first two
;;; outputs (static and dynamic environment locations) are attributed.

(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:enter-instruction))
  (let ((output-arrangement (output-arrangement instruction))
        (outputs (cleavir-ir:outputs instruction)))
    (setf (cleavir-ir:outputs instruction)
          (list* (find-register-in-arrangement output-arrangement
                                               (first outputs))
                 (find-register-in-arrangement output-arrangement
                                               (second outputs))
                 (nthcdr 2 outputs)))))

;;; Assignment instructions generated by SPILL and UNSPILL need to
;;; be converted to MEMSET2 and MEMREF2 instructions though.

(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:assignment-instruction))
  (let ((input  (first (cleavir-ir:inputs instruction)))
        (output (first (cleavir-ir:outputs instruction))))
    ;; Such assignments assign a lexical location to itself, so
    ;; any other assignments can be handled with the normal rule.
    (unless (and (eq input output)
                 (typep input 'cleavir-ir:lexical-location))
      (return-from introduce-registers-for-instruction
        (call-next-method)))
    (multiple-value-bind (in-stack in-register)
        (arr:find-attribution (input-arrangement instruction) input)
      (assert (not (and (null in-register)
                        (null in-stack)))
              ()
              "~S has no attribution in the input arrangement of ~S"
              input instruction)
      (multiple-value-bind (out-stack out-register)
          (arr:find-attribution (output-arrangement instruction) output)
        (assert (not (and (null out-register)
                          (null out-stack)))
              ()
              "~S has no attribution in the output arrangement of ~S"
              output instruction)
        (cond
          ((and (null in-stack) (not (null out-stack)))
           ;; This instruction is a spill.
           (replace-instruction
            instruction
            (save-to-stack-instruction in-register out-stack)))
          ((and (null in-register) (not (null out-register)))
           ;; This instruction is an unspill.
           (replace-instruction
            instruction
            (load-from-stack-instruction in-stack out-register)))
          ((and (not (null in-register)) (not (null in-register)))
           ;; This instruction is a plain register to register assignment.
           (setf (cleavir-ir:inputs instruction)
                 (list (aref *registers* in-register))
                 (cleavir-ir:outputs instruction)
                 (list (aref *registers* out-register))))
          (t
           (error "Not sure what the assignment of (~A, ~A) to (~A, ~A) is meant to be."
                  in-register in-stack out-register out-stack)))))))

;;; NOP-INSTRUCTIONs shouldn't have inputs and outputs, but we
;;; generate NOP-INSTRUCTIONs with inputs and outputs by CHANGE-CLASS
;;; somewhere.  So just ignore them until those are sniffed out.

(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:nop-instruction))
  nil)

;;; We have to do something for FUNCALL-INSTRUCTION,
;;; NAMED-CALL-INSTRUCTION and MULTIPLE-VALUE-CALL-INSTRUCTION, but I
;;; am not sure of what just yet.

(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:named-call-instruction))
  nil)

(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:funcall-instruction))
  nil)

(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:multiple-value-call-instruction))
  nil)

;;; The same goes for INITIALIZE-CLOSURE-INSTRUCTION

(defmethod introduce-registers-for-instruction
    ((instruction cleavir-ir:initialize-closure-instruction))
  nil)

(defun introduce-registers (mir)
  (cleavir-ir:map-local-instructions
   #'introduce-registers-for-instruction
   mir))
