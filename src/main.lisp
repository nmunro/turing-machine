(defpackage turing
  (:use :cl)
  (:export #:run-machine))
(in-package :turing)

(defun run-machine (stream)
  "Main loop, define op-codes and functions"
  (labels
      ((vm-resize-list (program new-size)
         (append program (make-list (1+ new-size) :initial-element 1)))

       (vm-initial-resize (program program-counter addresses values)
         ; Need to get the sum of addresses and values to ensure there's enough
         ; values next
         (let ((total (+ program-counter addresses values)))
           (if (> total (length program))
               (vm-resize-list program (- total (length program)))
               program)))

       (vm-address-resize (program program-counter addresses values)
         ; Get the sub sequences of addresses and values
         (let* ((addr-start (1+ program-counter))
                (addrs (subseq program addr-start (+ 1 program-counter addresses)))
                (vals (subseq program (+ addr-start addresses) (+ addr-start addresses values)))
                (max-addr (apply #'max (concatenate 'list addrs vals))))

           (if (> max-addr (length program))
               (vm-resize-list program (- max-addr (length program)))
               program)))

       (vm-check-and-resize-program (program program-counter &key (addresses 0) (values 0))
         (if (and (= 0 addresses) (= 0 values))
             program
             (vm-address-resize
              (vm-initial-resize program program-counter addresses values)
              program-counter
              addresses
              values)))

       (vm-calc (f program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :addresses 2 :values 1))
                (operand1 (nth (nth (+ 1 program-counter) new-program) new-program))
                (operand2 (nth (nth (+ 2 program-counter) new-program) new-program))
                (operand3 (nth (+ 3 program-counter) new-program)))
          (setf (nth operand3 new-program) (funcall f operand1 operand2))
          (values new-program (+ 4 program-counter))))

       (vm-no-op (program program-counter)
         (let ((new-program (vm-check-and-resize-program program program-counter)))
           (values new-program (1+ program-counter))))

       (vm-incr (program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :addresses 1))
                (operand (nth (+ 1 program-counter) new-program)))
                (setf (nth operand new-program) (1+ (nth operand new-program)))
                (values new-program (+ 2 program-counter))))

       (vm-decr (program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :addresses 1))
                (operand (nth (+ 1 program-counter) new-program)))
           (setf (nth operand new-program) (1- (nth operand new-program)))
           (values new-program (+ 2 program-counter))))

       (vm-jump (program program-counter)
         (let ((new-program (vm-check-and-resize-program program program-counter :values 1)))
           (values new-program (nth (1+ program-counter) new-program))))

       (vm-jif (program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :values 3))
                (operand1 (nth (+ 1 program-counter) new-program))
                (operand2 (nth (+ 2 program-counter) new-program))
                (operand3 (nth (+ 3 program-counter) new-program)))
           (values new-program (if (= 1 operand1) operand2 operand3))))

       (vm-equals (f program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :addresses 2 :values 1))
                (operand1 (nth (nth (+ 1 program-counter) new-program) new-program))
                (operand2 (nth (nth (+ 2 program-counter) new-program) new-program))
                (operand3 (nth (+ 3 program-counter) new-program)))
           (setf (nth operand3 new-program) (if (funcall f operand1 operand2) 1 0))
           (values new-program (+ 4 program-counter))))

       (vm-and (program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :addresses 2 :values 1))
                (operand1 (nth (nth (+ 1 program-counter) new-program) new-program))
                (operand2 (nth (nth (+ 2 program-counter) new-program) new-program))
                (operand3 (nth (+ 3 program-counter) new-program)))
           (setf (nth operand3 new-program) (if (and (> operand1 0) (> operand2 0)) 1 0))
           (values new-program (+ 4 program-counter))))

       (vm-or (program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :addresses 2 :values 1))
                (operand1 (nth (nth (+ 1 program-counter) new-program) new-program))
                (operand2 (nth (nth (+ 2 program-counter) new-program) new-program))
                (operand3 (nth (+ 3 program-counter) new-program)))
           (setf (nth operand3 new-program) (if (or (> operand1 0) (> operand2 0)) 1 0))
           (values new-program (+ 4 program-counter))))

       (vm-not (program program-counter)
         (let* ((new-program (vm-check-and-resize-program program program-counter :addresses 1 :values 1))
                (operand1 (nth (nth (+ 1 program-counter) new-program) new-program))
                (operand2 (nth (+ 2 program-counter) new-program)))
           (setf (nth operand2 new-program) (if (eq operand1 0) 1 0))
           (values new-program (+ 3 program-counter))))

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

           ;; Errors
           (T (format nil "~A program error" (nth program-counter program))))))

    (let ((program (mapcar #'parse-integer (uiop:split-string stream :separator ","))))
      (run-instruction program))))
