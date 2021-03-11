(cl:in-package #:sicl-boot)

(defun enable-generic-function-initialization (ea)
  (flet ((ld (path)
           (load-source-file path ea)))
    (ld "CLOS/generic-function-initialization-support.lisp")
    (ld "CLOS/generic-function-initialization-defmethods.lisp")))

(defun create-accessor-defgenerics (ea)
  (flet ((ld (path)
           (load-source-file path ea)))
    (ld "CLOS/specializer-direct-generic-functions-defgeneric.lisp")
    (ld "CLOS/setf-specializer-direct-generic-functions-defgeneric.lisp")
    (ld "CLOS/specializer-direct-methods-defgeneric.lisp")
    (ld "CLOS/setf-specializer-direct-methods-defgeneric.lisp")
    (ld "CLOS/unique-number-defgeneric.lisp")
    (ld "CLOS/class-name-defgeneric.lisp")
    (ld "CLOS/class-direct-subclasses-defgeneric.lisp")
    (ld "CLOS/setf-class-direct-subclasses-defgeneric.lisp")
    (ld "CLOS/class-direct-default-initargs-defgeneric.lisp")
    (ld "CLOS/documentation-defgeneric.lisp")
    (ld "CLOS/setf-documentation-defgeneric.lisp")
    (ld "CLOS/class-finalized-p-defgeneric.lisp")
    (ld "CLOS/setf-class-finalized-p-defgeneric.lisp")
    (ld "CLOS/class-precedence-list-defgeneric.lisp")
    (ld "CLOS/precedence-list-defgeneric.lisp")
    (ld "CLOS/setf-precedence-list-defgeneric.lisp")
    (ld "CLOS/instance-size-defgeneric.lisp")
    (ld "CLOS/setf-instance-size-defgeneric.lisp")
    (ld "CLOS/class-direct-slots-defgeneric.lisp")
    (ld "CLOS/class-direct-superclasses-defgeneric.lisp")
    (ld "CLOS/class-default-initargs-defgeneric.lisp")
    (ld "CLOS/setf-class-default-initargs-defgeneric.lisp")
    (ld "CLOS/class-slots-defgeneric.lisp")
    (ld "CLOS/setf-class-slots-defgeneric.lisp")
    (ld "CLOS/class-prototype-defgeneric.lisp")
    (ld "CLOS/setf-class-prototype-defgeneric.lisp")
    (ld "CLOS/dependents-defgeneric.lisp")
    (ld "CLOS/setf-dependents-defgeneric.lisp")
    (ld "CLOS/accessor-method-slot-definition-defgeneric.lisp")
    (ld "CLOS/setf-accessor-method-slot-definition-defgeneric.lisp")
    (ld "CLOS/slot-definition-storage-defgeneric.lisp")
    (ld "CLOS/slot-definition-readers-defgeneric.lisp")
    (ld "CLOS/slot-definition-writers-defgeneric.lisp")
    (ld "CLOS/slot-definition-location-defgeneric.lisp")
    (ld "CLOS/setf-slot-definition-location-defgeneric.lisp")
    (ld "CLOS/variant-signature-defgeneric.lisp")
    (ld "CLOS/template-defgeneric.lisp")
    (ld "Arithmetic/numerator-defgeneric.lisp")
    (ld "Arithmetic/denominator-defgeneric.lisp")
    (ld "Arithmetic/realpart-defgeneric.lisp")
    (ld "Arithmetic/imagpart-defgeneric.lisp")
    (ld "Array/array-dimensions-defgeneric.lisp")
    (ld "Array/vector-fill-pointer-defgeneric.lisp")
    (ld "Array/setf-vector-fill-pointer-defgeneric.lisp")
    (ld "Package-and-symbol/symbol-name-defgeneric.lisp")
    (ld "Package-and-symbol/symbol-package-defgeneric.lisp")))
