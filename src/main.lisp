(defpackage turing
  (:use :cl)
  (:export #:run-machine))
(in-package :turing)

;;;
;; There's a bug, one cannot set indexes beyond the length of the program
;; list must be resizable and populated with empty values
;;;

(defun run-machine (stream)
  "Main loop, define op-codes and functions"
  (labels
      ((calc (f program program-counter)
        (let ((operand1 (nth (nth (+ 1 program-counter) program) program))
              (operand2 (nth (nth (+ 2 program-counter) program) program))
              (operand3 (nth (+ 3 program-counter) program)))
          (setf (nth operand3 program) (funcall f operand1 operand2))
          (values program (+ 4 program-counter))))

       (no-op (program program-counter)
         (values program (1+ program-counter)))

       (incr (program program-counter)
         (let ((operand (nth (+ 1 program-counter) program)))
               (setf (nth operand program) (1+ (nth operand program)))
               (values program (+ 2 program-counter))))

       (decr (program program-counter)
         (let ((operand (nth (+ 1 program-counter) program)))
           (setf (nth operand program) (1- (nth operand program)))
           (values program (+ 2 program-counter))))

       (jump (program program-counter)
         (values program (nth (1+ program-counter) program)))

       (jif (program program-counter)
         (let ((operand1 (nth (+ 1 program-counter) program))
               (operand2 (nth (+ 2 program-counter) program))
               (operand3 (nth (+ 3 program-counter) program)))
           (values program (if (= 1 operand1) operand2 operand3))))

       (jnif (program program-counter)
         (let ((operand1 (nth (+ 1 program-counter) program))
               (operand2 (nth (+ 2 program-counter) program))
               (operand3 (nth (+ 3 program-counter) program)))
           (values program (if (= 0 operand1) operand2 operand3))))

       (equals (f program program-counter)
         (let ((operand1 (nth (nth (+ 1 program-counter) program) program))
               (operand2 (nth (nth (+ 2 program-counter) program) program))
               (operand3 (nth (+ 3 program-counter) program)))
           (setf (nth operand3 program) (if (funcall f operand1 operand2) 1 0))
           (values program (+ 4 program-counter))))

       (run-instruction (program &optional (program-counter 0))
         (cond
           ;; Halt, returning the state of the program
           ((= 0 (nth program-counter program))
            program)

           ;; No-op
           ((= 1 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (no-op program program-counter)
                                 (run-instruction program program-counter)))

           ;; Add
           ((= 101 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (calc #'+ program program-counter)
                                 (run-instruction program program-counter)))

           ;; Multiply
           ((= 102 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (calc #'* program program-counter)
                                 (run-instruction program program-counter)))

           ;; Subtract
           ((= 103 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (calc #'- program program-counter)
                                 (run-instruction program program-counter)))

           ;; Divide
           ((= 104 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (calc #'/ program program-counter)
                                 (run-instruction program program-counter)))

           ;; Incr
           ((= 105 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (incr program program-counter)
                                 (run-instruction program program-counter)))

           ;; Decr
           ((= 106 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (decr program program-counter)
                                 (run-instruction program program-counter)))

           ;; Jump
           ((= 201 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (jump program program-counter)
                                 (run-instruction program program-counter)))

           ;; Jump if
           ((= 202 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (jif program program-counter)
                                 (run-instruction program program-counter)))

           ;; Jump if not
           ((= 203 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (jnif program program-counter)
                                 (run-instruction program program-counter)))

           ;; equal
           ((= 301 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (equals #'= program program-counter)
                                 (run-instruction program program-counter)))

           ;; Greater than
           ((= 302 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (equals #'> program program-counter)
                                 (run-instruction program program-counter)))

           ;; Greater than equal to
           ((= 303 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (equals #'>= program program-counter)
                                 (run-instruction program program-counter)))

           ;; Less than
           ((= 304 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (equals #'< program program-counter)
                                 (run-instruction program program-counter)))

           ;; Less than equal to
           ((= 305 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (equals #'<= program program-counter)
                                 (run-instruction program program-counter)))

           ; Errors
           (T (format nil "~A program error" (nth program-counter program))))))

    (let ((program (mapcar #'parse-integer (uiop:split-string stream :separator ","))))
      (run-instruction program))))
