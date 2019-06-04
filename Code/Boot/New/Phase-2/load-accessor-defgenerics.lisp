(cl:in-package #:sicl-boot-phase-2)

(defun load-accessor-defgenerics (e3)
  (flet ((ld (relative-pathname)
           (format *trace-output* "Loading ~s~%" relative-pathname)
           (sicl-boot:load-fasl relative-pathname e3)))
    (ld "CLOS/specializer-direct-generic-functions-defgeneric.fasl")
    (ld "CLOS/setf-specializer-direct-generic-functions-defgeneric.fasl")
    (ld "CLOS/specializer-direct-methods-defgeneric.fasl")
    (ld "CLOS/setf-specializer-direct-methods-defgeneric.fasl")
    (ld "CLOS/eql-specializer-object-defgeneric.fasl")
    (ld "CLOS/unique-number-defgeneric.fasl")
    (ld "CLOS/class-name-defgeneric.fasl")
    (ld "CLOS/class-direct-subclasses-defgeneric.fasl")
    (ld "CLOS/setf-class-direct-subclasses-defgeneric.fasl")
    (ld "CLOS/class-direct-default-initargs-defgeneric.fasl")
    (ld "CLOS/documentation-defgeneric.fasl")
    (ld "CLOS/setf-documentation-defgeneric.fasl")
    (ld "CLOS/class-finalized-p-defgeneric.fasl")
    (ld "CLOS/setf-class-finalized-p-defgeneric.fasl")
    (ld "CLOS/class-precedence-list-defgeneric.fasl")
    (ld "CLOS/precedence-list-defgeneric.fasl")
    (ld "CLOS/setf-precedence-list-defgeneric.fasl")
    (ld "CLOS/instance-size-defgeneric.fasl")
    (ld "CLOS/setf-instance-size-defgeneric.fasl")
    (ld "CLOS/class-direct-slots-defgeneric.fasl")
    (ld "CLOS/class-direct-superclasses-defgeneric.fasl")
    (ld "CLOS/class-default-initargs-defgeneric.fasl")
    (ld "CLOS/setf-class-default-initargs-defgeneric.fasl")
    (ld "CLOS/class-slots-defgeneric.fasl")
    (ld "CLOS/setf-class-slots-defgeneric.fasl")
    (ld "CLOS/class-prototype-defgeneric.fasl")
    (ld "CLOS/setf-class-prototype-defgeneric.fasl")
    (ld "CLOS/dependents-defgeneric.fasl")
    (ld "CLOS/setf-dependents-defgeneric.fasl")
    (ld "CLOS/generic-function-name-defgeneric.fasl")
    (ld "CLOS/generic-function-lambda-list-defgeneric.fasl")
    (ld "CLOS/generic-function-argument-precedence-order-defgeneric.fasl")
    (ld "CLOS/generic-function-declarations-defgeneric.fasl")
    (ld "CLOS/generic-function-method-class-defgeneric.fasl")
    (ld "CLOS/generic-function-method-combination-defgeneric.fasl")
    (ld "CLOS/generic-function-methods-defgeneric.fasl")
    (ld "CLOS/setf-generic-function-methods-defgeneric.fasl")
    (ld "CLOS/initial-methods-defgeneric.fasl")
    (ld "CLOS/setf-initial-methods-defgeneric.fasl")
    (ld "CLOS/call-history-defgeneric.fasl")
    (ld "CLOS/setf-call-history-defgeneric.fasl")
    (ld "CLOS/specializer-profile-defgeneric.fasl")
    (ld "CLOS/setf-specializer-profile-defgeneric.fasl")
    (ld "CLOS/method-function-defgeneric.fasl")
    (ld "CLOS/method-generic-function-defgeneric.fasl")
    (ld "CLOS/setf-method-generic-function-defgeneric.fasl")
    (ld "CLOS/method-lambda-list-defgeneric.fasl")
    (ld "CLOS/method-specializers-defgeneric.fasl")
    (ld "CLOS/method-qualifiers-defgeneric.fasl")
    (ld "CLOS/accessor-method-slot-definition-defgeneric.fasl")
    (ld "CLOS/setf-accessor-method-slot-definition-defgeneric.fasl")
    (ld "CLOS/slot-definition-name-defgeneric.fasl")
    (ld "CLOS/slot-definition-allocation-defgeneric.fasl")
    (ld "CLOS/slot-definition-type-defgeneric.fasl")
    (ld "CLOS/slot-definition-initargs-defgeneric.fasl")
    (ld "CLOS/slot-definition-initform-defgeneric.fasl")
    (ld "CLOS/slot-definition-initfunction-defgeneric.fasl")
    (ld "CLOS/slot-definition-storage-defgeneric.fasl")
    (ld "CLOS/slot-definition-readers-defgeneric.fasl")
    (ld "CLOS/slot-definition-writers-defgeneric.fasl")
    (ld "CLOS/slot-definition-location-defgeneric.fasl")
    (ld "CLOS/setf-slot-definition-location-defgeneric.fasl")
    (ld "CLOS/variant-signature-defgeneric.fasl")
    (ld "CLOS/template-defgeneric.fasl")
    (ld "Package-and-symbol/symbol-name-defgeneric.fasl")
    (ld "Package-and-symbol/symbol-package-defgeneric.fasl")))
