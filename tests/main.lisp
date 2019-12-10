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

(deftest test-noop-1
  (testing "should (equal '(1 1 1 1 1 101 0 0 10 0 2) (run-machine \"1,1,1,1,1,101,0,0,10,0,2\")) to be true"
    (ok (equal '(1 1 1 1 1 101 0 0 10 0 2) (run-machine "1,1,1,1,1,101,0,0,10,0,2")))))

(deftest test-gt-1
  (testing "should (equal '(302 0 1 1 0) (run-machine \"302,0,1,3,0\")) to be true"
    (ok (equal '(302 0 1 1 0) (run-machine "302,0,1,3,0")))))

(deftest test-gt-2
  (testing "should (equal '(302 5 6 0 0 1 2) (run-machine \"302,5,6,3,0,1,2\")) to be true"
    (ok (equal '(302 5 6 0 0 1 2) (run-machine "302,5,6,3,0,1,2")))))

(deftest test-gte-1
  (testing "should (equal '(303 0 1 1 0) (run-machine \"303,0,1,3,0\")) to be true"
    (ok (equal '(303 0 1 1 0) (run-machine "303,0,1,3,0")))))

(deftest test-gte-2
  (testing "should (equal '(303 0 0 1 0) (run-machine \"303,0,0,3,0\")) to be true"
    (ok (equal '(303 0 0 1 0) (run-machine "303,0,0,3,0")))))

(deftest test-gte-3
  (testing "should (equal '(303 5 6 0 0 1 2) (run-machine \"303,5,6,3,0,1,2\")) to be true"
    (ok (equal '(303 5 6 0 0 1 2) (run-machine "303,5,6,3,0,1,2")))))

(deftest test-lt-1
  (testing "should (equal '(304 1 0 1 0) (run-machine \"304,2,0,1,0\")) to be true"
    (ok (equal '(304 1 0 1 0) (run-machine "304,2,0,1,0")))))

(deftest test-lt-2
  (testing "should (equal '(304 5 6 1 0 1 2) (run-machine \"304,5,6,3,0,1,2\")) to be true"
    (ok (equal '(304 5 6 1 0 1 2) (run-machine "304,5,6,3,0,1,2")))))

(deftest test-lte-1
  (testing "should (equal '(305 1 0 1 0) (run-machine \"305,1,0,3,0\")) to be true"
    (ok (equal '(305 1 0 1 0) (run-machine "305,1,0,3,0")))))

(deftest test-lte-2
  (testing "should (equal '(305 0 0 1 0) (run-machine \"305,0,0,3,0\")) to be true"
    (ok (equal '(305 0 0 1 0) (run-machine "305,0,0,3,0")))))

(deftest test-lte-3
  (testing "should (equal '(305 6 5 0 0 1 2) (run-machine \"305,6,5,3,0,1,2\")) to be true"
    (ok (equal '(305 6 5 0 0 1 2) (run-machine "305,6,5,3,0,1,2")))))

(deftest test-jif-1
  (testing "should (equal '(202 1 5 10 6 101 1 2 4 0 102 1 2 4 0) (run-machine \"202,1,5,0,0,101,1,2,3,0,102,1,2,3,0\")) to be true"
    (ok (equal '(202 1 5 10 6 101 1 2 4 0 102 1 2 4 0) (run-machine "202,1,5,10,6,101,1,2,4,0,102,1,2,4,0")))))

(deftest test-jif-2
  (testing "should (equal '(202 0 5 10 0 101 1 2 4 0 102 1 2 4 0) (run-machine \"202,0,5,10,5,101,1,2,4,0,102,1,2,4,0\")) to be true"
    (ok (equal '(202 0 5 10 0 101 1 2 4 0 102 1 2 4 0) (run-machine "202,0,5,10,5,101,1,2,4,0,102,1,2,4,0")))))

(deftest test-jnif-1
  (testing "should (equal '(203 1 5 10 5 101 1 2 4 0 102 1 2 4 0) (run-machine \"203,1,5,0,0,101,1,2,3,0,102,1,2,3,0\")) to be true"
    (ok (equal '(203 1 5 10 5 101 1 2 4 0 102 1 2 4 0) (run-machine "203,1,5,10,5,101,1,2,4,0,102,1,2,4,0")))))

(deftest test-jnif-2
  (testing "should (equal '(203 0 5 5 0 101 1 2 4 0 102 1 2 4 0) (run-machine \"203,0,5,10,5,101,1,2,4,0,102,1,2,4,0\")) to be true"
    (ok (equal '(203 0 5 10 5 101 1 2 4 0 102 1 2 4 0) (run-machine "203,0,5,10,5,101,1,2,4,0,102,1,2,4,0")))))
