(defsystem "turing"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "turing/tests"))))

(defsystem "turing/tests"
  :author ""
  :license ""
  :depends-on ("turing"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for turing"
  :perform (test-op (op c) (symbol-call :rove :run c)))
