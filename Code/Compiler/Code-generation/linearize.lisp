(cl:in-package #:sicl-code-generation)

(defun linearize-lir (enter-instruction)
  (let ((result '())
        (global-worklist (list enter-instruction)))
    (flet ((entry-point-input-p (input)
             (typep input 'sicl-hir-to-mir:entry-point-input)))
      (loop until (null global-worklist)
            do (let ((local-worklist (list (pop global-worklist)))
                     (visited (make-hash-table :test #'eq)))
                 (loop until (null local-worklist)
                       do (let ((instruction (pop local-worklist)))
                            (unless (gethash instruction visited)
                              (setf (gethash instruction visited) t)
                              (push instruction result)
                              (let ((entry (find-if #'entry-point-input-p
                                                    (cleavir-ir:inputs instruction))))
                                (unless (null entry)
                                  (push (sicl-hir-to-mir:enter-instruction entry)
                                        global-worklist)))
                              (loop for successor in (reverse (cleavir-ir:successors instruction))
                                    do (push successor local-worklist))))))))
    (reverse result)))
