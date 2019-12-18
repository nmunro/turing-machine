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
      ((vm-calc (f program program-counter)
        (let ((operand1 (nth (nth (+ 1 program-counter) program) program))
              (operand2 (nth (nth (+ 2 program-counter) program) program))
              (operand3 (nth (+ 3 program-counter) program)))
          (setf (nth operand3 program) (funcall f operand1 operand2))
          (values program (+ 4 program-counter))))

       (vm-no-op (program program-counter)
         (values program (1+ program-counter)))

       (vm-incr (program program-counter)
         (let ((operand (nth (+ 1 program-counter) program)))
               (setf (nth operand program) (1+ (nth operand program)))
               (values program (+ 2 program-counter))))

       (vm-decr (program program-counter)
         (let ((operand (nth (+ 1 program-counter) program)))
           (setf (nth operand program) (1- (nth operand program)))
           (values program (+ 2 program-counter))))

       (vm-jump (program program-counter)
         (values program (nth (1+ program-counter) program)))

       (vm-jif (program program-counter)
         (let ((operand1 (nth (+ 1 program-counter) program))
               (operand2 (nth (+ 2 program-counter) program))
               (operand3 (nth (+ 3 program-counter) program)))
           (values program (if (= 1 operand1) operand2 operand3))))

       (vm-equals (f program program-counter)
         (let ((operand1 (nth (nth (+ 1 program-counter) program) program))
               (operand2 (nth (nth (+ 2 program-counter) program) program))
               (operand3 (nth (+ 3 program-counter) program)))
           (setf (nth operand3 program) (if (funcall f operand1 operand2) 1 0))
           (values program (+ 4 program-counter))))

       (vm-and (program program-counter)
         (let ((operand1 (nth (nth (+ 1 program-counter) program) program))
               (operand2 (nth (nth (+ 2 program-counter) program) program))
               (operand3 (nth (+ 3 program-counter) program)))
           (setf (nth operand3 program) (if (and (> operand1 0) (> operand2 0)) 1 0))
           (values program (+ 4 program-counter))))

       (vm-or (program program-counter)
         (let ((operand1 (nth (nth (+ 1 program-counter) program) program))
               (operand2 (nth (nth (+ 2 program-counter) program) program))
               (operand3 (nth (+ 3 program-counter) program)))
           (setf (nth operand3 program) (if (or (> operand1 0) (> operand2 0)) 1 0))
           (values program (+ 4 program-counter))))

       (vm-not (program program-counter)
         (let ((operand1 (nth (nth (+ 1 program-counter) program) program))
               (operand2 (nth (+ 2 program-counter) program)))
           (setf (nth operand2 program) (if (eq operand1 0) 1 0))
           (values program (+ 3 program-counter))))

       (run-instruction (program &optional (program-counter 0))
         (cond
           ;; Halt, returning the state of the program
           ((= 0 (nth program-counter program))
            program)

           ;; No-op
           ((= 1 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-no-op program program-counter)
                                 (run-instruction program program-counter)))

           ;; Add
           ((= 101 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-calc #'+ program program-counter)
                                 (run-instruction program program-counter)))

           ;; Multiply
           ((= 102 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-calc #'* program program-counter)
                                 (run-instruction program program-counter)))

           ;; Subtract
           ((= 103 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-calc #'- program program-counter)
                                 (run-instruction program program-counter)))

           ;; Divide
           ((= 104 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-calc #'/ program program-counter)
                                 (run-instruction program program-counter)))

           ;; Incr
           ((= 105 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-incr program program-counter)
                                 (run-instruction program program-counter)))

           ;; Decr
           ((= 106 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-decr program program-counter)
                                 (run-instruction program program-counter)))

           ;; Jump
           ((= 201 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-jump program program-counter)
                                 (run-instruction program program-counter)))

           ;; Jump if
           ((= 202 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-jif program program-counter)
                                 (run-instruction program program-counter)))

           ;; equal
           ((= 301 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-equals #'= program program-counter)
                                 (run-instruction program program-counter)))

           ;; Greater than
           ((= 302 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-equals #'> program program-counter)
                                 (run-instruction program program-counter)))

           ;; Greater than equal to
           ((= 303 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-equals #'>= program program-counter)
                                 (run-instruction program program-counter)))

           ;; Less than
           ((= 304 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-equals #'< program program-counter)
                                 (run-instruction program program-counter)))

           ;; Less than equal to
           ((= 305 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-equals #'<= program program-counter)
                                 (run-instruction program program-counter)))

           ;; Boolean and
           ((= 306 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-and program program-counter)
                                 (run-instruction program program-counter)))

           ;; Boolean or
           ((= 307 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-or program program-counter)
                                 (run-instruction program program-counter)))

           ;; Boolean not
           ((= 308 (nth program-counter program))
            (multiple-value-bind (program program-counter)
                                 (vm-not program program-counter)
                                 (run-instruction program program-counter)))

           ; Errors
           (T (format nil "~A program error" (nth program-counter program))))))

    (let ((program (mapcar #'parse-integer (uiop:split-string stream :separator ","))))
      (run-instruction program))))
