(defpackage turing
  (:use :cl)
  (:export #:werk))
(in-package :turing)

(defun werk (stream)
  ; Main loop, define op-codes and functions
  (labels
      ((math (f program stack-pointer)
        (let ((operand1 (nth (nth (+ 1 stack-pointer) program) program))
              (operand2 (nth (nth (+ 2 stack-pointer) program) program))
              (operand3 (nth (+ 3 stack-pointer) program)))
          (setf (nth operand3 program) (funcall f operand1 operand2))
          program))

       (equals (program stack-pointer)
         (let ((operand1 (nth (nth (+ 1 stack-pointer) program) program))
               (operand2 (nth (nth (+ 2 stack-pointer) program) program))
               (operand3 (nth (+ 3 stack-pointer) program)))
           (setf (nth operand3 program) (if (= operand1 operand2) 1 0))
           program))

       (if-else (program stack-pointer)
         (let* ((program  (equals program stack-pointer))
                (result   (nth (nth (+ 3 stack-pointer) program) program))
                (branch-1 (nth (nth (+ 4 stack-pointer) program) program))
                (branch-2 (nth (nth (+ 5 stack-pointer) program) program)))
           (values program (if result branch-1 branch-2))))

       (run-instruction (program &optional (stack-pointer 0))
         (format t "~A~%" stack-pointer)
         (cond
           ; Halt, returning the state of the program
           ((= 99 (nth stack-pointer program)) program)

           ; Math operations
           ((= 1  (nth stack-pointer program)) (run-instruction (math #'+ program stack-pointer) (+ stack-pointer 4)))
           ((= 2  (nth stack-pointer program)) (run-instruction (math #'* program stack-pointer) (+ stack-pointer 4)))
           ((= 3  (nth stack-pointer program)) (run-instruction (math #'- program stack-pointer) (+ stack-pointer 4)))
           ((= 4  (nth stack-pointer program)) (run-instruction (math #'/ program stack-pointer) (+ stack-pointer 4)))

           ;  Program flow
           ((= 5  (nth stack-pointer program)) (run-instruction program (nth (1+ stack-pointer) program)))
           ((= 55 (nth stack-pointer program)) (multiple-value-bind (program stack-pointer)
                                                                    (if-else program (nth (1+ stack-pointer) program))
                                                 (run-instruction program stack-pointer)))

           ; Equality
           ((= 6 (nth stack-pointer program)) (run-instruction (equals program stack-pointer) (+ stack-pointer 4)))

           ; Errors
           (T (format nil "~A program error" (nth stack-pointer program))))))

    (let ((program (mapcar #'parse-integer (uiop:split-string stream :separator ","))))
      (run-instruction program))))

(werk "55,15,0,13,6,10,1,0,0,16,2,0,0,16,99,55,0")
