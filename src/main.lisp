(defpackage turing
  (:use :cl)
  (:export #:werk))
(in-package :turing)

;;;
;; There's a bug, one cannot set indexes beyond the length of the program
;; list must be resizable and populated with empty values
;;;

(defun werk (stream)
  ; Main loop, define op-codes and functions
  (labels
      ((calc (f program stack-pointer)
        (let ((operand1 (nth (nth (+ 1 stack-pointer) program) program))
              (operand2 (nth (nth (+ 2 stack-pointer) program) program))
              (operand3 (nth (+ 3 stack-pointer) program)))
          (setf (nth operand3 program) (funcall f operand1 operand2))
          (values program (+ 4 stack-pointer))))

       (jump (program stack-pointer)
         (values program (nth (1+ stack-pointer) program)))

       (jump-if (program stack-pointer)
         0)

       (jump-nif (program stack-pointer)
         0)

       (equals (program stack-pointer)
         (let ((operand1 (nth (nth (+ 1 stack-pointer) program) program))
               (operand2 (nth (nth (+ 2 stack-pointer) program) program))
               (operand3 (nth (+ 3 stack-pointer) program)))
           (setf (nth operand3 program) (if (= operand1 operand2) 1 0))
           (values program (+ 4 stack-pointer))))

       (run-instruction (program &optional (stack-pointer 0))
         (cond
           ;; Halt, returning the state of the program
           ((= 0 (nth stack-pointer program))
            program)

           ;; Add
           ((= 101 (nth stack-pointer program))
            (multiple-value-bind (program stack-pointer)
                                 (calc #'+ program stack-pointer)
                                 (run-instruction program stack-pointer)))

           ;; Multiply
           ((= 102 (nth stack-pointer program))
            (multiple-value-bind (program stack-pointer)
                                 (calc #'* program stack-pointer)
                                 (run-instruction program stack-pointer)))

           ;; Subtract
           ((= 103 (nth stack-pointer program))
            (multiple-value-bind (program stack-pointer)
                                 (calc #'- program stack-pointer)
                                 (run-instruction program stack-pointer)))

           ;; Divide
           ((= 104 (nth stack-pointer program))
            (multiple-value-bind (program stack-pointer)
                                 (calc #'/ program stack-pointer)
                                 (run-instruction program stack-pointer)))

           ;;  Program flow
           ((= 201  (nth stack-pointer program))
            (multiple-value-bind (program stack-pointer)
                                 (jump program stack-pointer)
                                 (run-instruction program stack-pointer)))

           ; Equality
           ((= 301 (nth stack-pointer program))
            (multiple-value-bind (program stack-pointer)
                                 (equals program stack-pointer)
                                 (run-instruction program stack-pointer)))

           ; Errors
           (T (format nil "~A program error" (nth stack-pointer program))))))

    (let ((program (mapcar #'parse-integer (uiop:split-string stream :separator ","))))
      (run-instruction program))))

(werk "201,7,6,2,4,1,0,104,2,3,4,0")
