(cl:in-package #:sicl-hir-to-mir)

(defun box-unsigned-integer (instruction)
  (let ((word-location (make-instance 'cleavir-ir:raw-integer :size 64))
        (shift-count-input (make-instance 'cleavir-ir:immediate-input :value 1)))
    (cleavir-ir:insert-instruction-before
     (make-instance 'cleavir-ir:assignment-instruction
       :inputs (cleavir-ir:inputs instruction)
       :output word-location
       :successor instruction)
     instruction)
    (change-class instruction 'cleavir-ir:shift-left-instruction
                  :shifted-input word-location
                  :shift-count shift-count-input)))

(defun box-signed-integer (instruction)
  (let ((word-location (make-instance 'cleavir-ir:raw-integer :size 64))
        (shift-count-input (make-instance 'cleavir-ir:immediate-input :value 1)))
    (cleavir-ir:insert-instruction-before
     (make-instance 'cleavir-ir:sign-extend-instruction
       :inputs (cleavir-ir:inputs instruction)
       :output word-location
       :successor instruction)
     instruction)
    (change-class instruction 'cleavir-ir:shift-left-instruction
                  :shifted-input word-location
                  :shift-count shift-count-input)))

(defun box-single-float (instruction)
  (let ((word-location-1 (make-instance 'cleavir-ir:raw-integer :size 64))
        (word-location-2 (make-instance 'cleavir-ir:raw-integer :size 64))
        (shift-count-input (make-instance 'cleavir-ir:immediate-input :value 32))
        (tag-input (make-instance 'cleavir-ir:immediate-input :value #b10011)))
    (cleavir-ir:insert-instruction-before
     (make-instance 'cleavir-ir:assignment-instruction
       :inputs (cleavir-ir:inputs instruction)
       :output word-location-1
       :successor instruction)
     instruction)
    (cleavir-ir:insert-instruction-before
     (make-instance 'cleavir-ir:shift-left-instruction
       :shifted-input word-location-1
       :shift-count shift-count-input
       :output word-location-2
       :successor instruction)
     instruction)
    (change-class instruction 'cleavir-ir:bitwise-or-instruction
                  :inputs (list word-location-2 tag-input))))

(defmethod process-instruction
    (client (instruction cleavir-ir:box-instruction) code-object)
  (let ((element-type (cleavir-ir:element-type instruction)))
    (cond ((member element-type
                   '(bit
                     (unsigned-byte 8)
                     (unsigned-byte 16)
                     (unsigned-byte 32))
                   :test #'equal)
           (box-unsigned-integer instruction))
          ((member element-type
                   '((signed-byte 8)
                     (signed-byte 16)
                     (signed-byte 32))
                   :test #'equal)
           (box-signed-integer instruction))
          ((eq element-type 'single-float)
           (box-single-float instruction))
          ((eq element-type 'double-float)
           (let* ((dynamic-environment
                    (cleavir-ir:dynamic-environment-location instruction))
                  (double-float-constant-location
                    (make-instance 'cleavir-ir:lexical-location
                      :name (gensym)))
                  (object-location
                    (make-instance 'cleavir-ir:lexical-location
                      :name (gensym)))
                  (call-instruction
                    (make-instance 'cleavir-ir:named-call-instruction
                      :dynamic-environment-location dynamic-environment
                      :callee-name 'make-instance
                      :input double-float-constant-location)))
             (sicl-compiler:establish-call-site instruction code-object)
             (cleavir-ir:insert-instruction-before
              (make-instance 'cleavir-ir:load-constant-instruction
                :dynamic-environment-location dynamic-environment
                :output double-float-constant-location
                :location-info
                (sicl-compiler:ensure-constant code-object 'double-float))
              instruction)
             (cleavir-ir:insert-instruction-before call-instruction instruction)
             (cleavir-ir:insert-instruction-before
              (make-instance 'cleavir-ir:return-value-instruction
                :dynamic-environment-location dynamic-environment
                :input (make-instance 'cleavir-ir:immediate-input :value 0)
                :output (first (cleavir-ir:outputs instruction)))
              instruction)
             (change-class instruction 'cleavir-ir:nook-write-instruction
                           :inputs (list object-location
                                         (make-instance 'cleavir-ir:immediate-input
                                           :value 3)
                                         (first (cleavir-ir:inputs instruction))))))
          (t
           (error "Don't know how to box ~s" element-type)))))

(defun unbox-integer (instruction)
  (let ((word-location (make-instance 'cleavir-ir:raw-integer :size 64))
        (shift-count-input (make-instance 'cleavir-ir:immediate-input :value 1)))
    (cleavir-ir:insert-instruction-before
     (make-instance 'cleavir-ir:arithmetic-shift-right-instruction
       :shifted-input (first (cleavir-ir:inputs instruction))
       :shift-count shift-count-input
       :output word-location
       :successor instruction)
     instruction)
    (change-class instruction 'cleavir-ir:assignment-instruction
                  :inputs (list word-location))))

(defun unbox-single-float (instruction)
  (let ((word-location (make-instance 'cleavir-ir:raw-integer :size 64))
        (shift-count-input (make-instance 'cleavir-ir:immediate-input :value 32)))
    (cleavir-ir:insert-instruction-before
     (make-instance 'cleavir-ir:arithmetic-shift-right-instruction
       :shifted-input (first (cleavir-ir:inputs instruction))
       :shift-count shift-count-input
       :output word-location
       :successor instruction)
     instruction)
    (change-class instruction 'cleavir-ir:assignment-instruction
                  :inputs (list word-location))))

(defmethod process-instruction
    (client (instruction cleavir-ir:unbox-instruction) code-object)
  (let ((element-type (cleavir-ir:element-type instruction)))
    (cond ((member element-type
                   '(bit
                     (unsigned-byte 8)
                     (unsigned-byte 16)
                     (unsigned-byte 32)
                     (signed-byte 8)
                     (signed-byte 16)
                     (signed-byte 32))
                   :test #'equal)
           (unbox-integer instruction))
          ((eq element-type 'single-float)
           (unbox-single-float instruction))
          ((eq element-type 'double-float)
           (change-class instruction 'cleavir-ir:nook-read-instruction
                         :inputs (list (first (cleavir-ir:inputs instruction))
                                       (make-instance 'cleavir-ir:immediate-input
                                         :value 3))))
          (t
           (error "Don't know how to unbox ~s" element-type)))))
