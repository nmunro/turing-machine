(defpackage turing/tests/main
  (:use :cl
        :turing
        :rove))
(in-package :turing/tests/main)

;; NOTE: To run-machine this test file, execute `(asdf:test-system :turing)' in your Lisp.

(deftest test-add-halt-1
  (testing "should (equal '(202 0 0 0 0) (run-machine \"101,0,0,0,0\")) to be true"
    (ok (equal '(202 0 0 0 0) (run-machine "101,0,0,0,0")))))

(deftest test-add-halt-2
  (testing "should (equal '(102 3 0 306 0) (run-machine \"102,3,0,3,0\")) to be true"
    (ok (equal '(102 3 0 306 0) (run-machine "102,3,0,3,0")))))

(deftest test-add-halt-3
  (testing "should (equal '(3 5 6 0 0 5 -2) (run-machine \"101,5,6,0,0,5,-2\")) to be true"
    (ok (equal '(3 5 6 0 0 5 -2) (run-machine "101,5,6,0,0,5,-2")))))

(deftest test-multiply-halt-1
  (testing "should (equal '(102 9801 5 1 0 99) (run-machine \"102,5,5,1,0,99\")) to be true"
    (ok (equal '(102 9801 5 1 0 99) (run-machine "102,5,5,1,0,99")))))

(deftest test-multiply-halt-2
  (testing "should (equal '(30 1 9 4 102 5 6 0 0 101) (run-machine \"101,1,9,4,0,5,6,0,0,101\")) to be true"
    (ok (equal '(30 1 9 4 102 5 6 0 0 101) (run-machine "101,1,9,4,0,5,6,0,0,101")))))

(deftest test-add-multiply-halt-1
  (testing "should (equal '(3500 9 10 70 102 3 11 0 0 30 40 50) (run-machine \"101,9,10,3,102,3,11,0,0,30,40,50\")) to be true"
    (ok (equal '(3500 9 10 70 102 3 11 0 0 30 40 50) (run-machine "101,9,10,3,102,3,11,0,0,30,40,50")))))

(deftest test-subtract-halt-1
  (testing "should (equal '(8 5 6 0 0 10 2) (run-machine \"103,5,6,0,0,10,2\")) to be true"
    (ok (equal '(8 5 6 0 0 10 2) (run-machine "103,5,6,0,0,10,2")))))

(deftest test-divide-halt-1
  (testing "should (equal '(5 5 6 0 0 10 2) (run-machine \"104,5,6,0,0,10,2\")) to be true"
    (ok (equal '(5 5 6 0 0 10 2) (run-machine "104,5,6,0,0,10,2")))))

(deftest test-jump-1
  (testing "should (equal '(201 402 0 0 101 0 0 1 0) (run-machine \"201,4,0,0,101,0,0,1,0\")) to be true"
    (ok (equal '(201 402 0 0 101 0 0 1 0) (run-machine "201,4,0,0,101,0,0,1,0")))))

(deftest test-jump-2
  (testing "should (equal '(201 7 6 2 3 1 0 104 2 3 4 0) (run-machine \"201,7,6,2,4,1,0,104,2,3,4,0\")) to be true"
    (ok (equal '(201 7 6 2 3 1 0 104 2 3 4 0) (run-machine "201,7,6,2,4,1,0,104,2,3,4,0")))))

(deftest test-equality-1
  (testing "should (equal '(301 1 1 5 0 1) (run-machine \"301,1,1,5,0,0\")) to be true"
    (ok (equal '(301 1 1 5 0 1) (run-machine "301,1,1,5,0,0")))))

;(deftest test-if-else-1
;  (testing "should (equal '(0) (run-machine \"55,12,0,13,6,10,1,0,0,16,2,0,0,16,0,55,0\")) to be true"
;    (ok (equal '(0) (run-machine "55,12,0,13,6,10,1,0,0,16,2,0,0,16,0,55,0")))))
