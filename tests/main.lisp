(defpackage turing/tests/main
  (:use :cl
        :turing
        :rove))
(in-package :turing/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :turing)' in your Lisp.

(deftest test-add-halt-1
  (testing "should (equal '(2 0 0 0 99) (werk \"1,0,0,0,99\")) to be true"
    (ok (equal '(2 0 0 0 99) (werk "1,0,0,0,99")))))

(deftest test-add-halt-2
  (testing "should (equal '(2 3 0 6 99) (werk \"2,3,0,3,99\")) to be true"
    (ok (equal '(2 3 0 6 99) (werk "2,3,0,3,99")))))

(deftest test-add-halt-3
  (testing "should (equal '(3 5 6 0 99 5 -2) (werk \"1,5,6,0,99,5,-2\")) to be true"
    (ok (equal '(3 5 6 0 99 5 -2) (werk "1,5,6,0,99,5,-2")))))

(deftest test-multiply-halt-1
  (testing "should (equal '(2 4 4 5 99 9801) (werk \"2,4,4,5,99,0\")) to be true"
    (ok (equal '(2 4 4 5 99 9801) (werk "2,4,4,5,99,0")))))

(deftest test-multiply-halt-2
  (testing "should (equal '(30 1 1 4 2 5 6 0 99) (werk \"1,1,1,4,99,5,6,0,99\")) to be true"
    (ok (equal '(30 1 1 4 2 5 6 0 99) (werk "1,1,1,4,99,5,6,0,99")))))

(deftest test-add-multiply-halt-1
  (testing "should (equal '(3500 9 10 70 2 3 11 0 99 30 40 50) (werk \"1,9,10,3,2,3,11,0,99,30,40,50\")) to be true"
    (ok (equal '(3500 9 10 70 2 3 11 0 99 30 40 50) (werk "1,9,10,3,2,3,11,0,99,30,40,50")))))

(deftest test-subtract-halt-1
  (testing "should (equal '(8 5 6 0 99 10 2) (werk \"3,5,6,0,99,10,2\")) to be true"
    (ok (equal '(8 5 6 0 99 10 2) (werk "3,5,6,0,99,10,2")))))

(deftest test-divide-halt-1
  (testing "should (equal '(5 5 6 0 99 10 2) (werk \"4,5,6,0,99,10,2\")) to be true"
    (ok (equal '(5 5 6 0 99 10 2) (werk "4,5,6,0,99,10,2")))))

(deftest test-jump-1
  (testing "should (equal '(5 10 0 0 1 0 0 1 99) (werk \"5,4,0,0,1,0,0,1,99\")) to be true"
    (ok (equal '(5 10 0 0 1 0 0 1 99) (werk "5,4,0,0,1,0,0,1,99")))))

(deftest test-jump-2
  (testing "should (equal '(5 10 1 0 0 1 99 5 2) (werk \"5,7,1,0,0,1,99,5,2\")) to be true"
    (ok (equal '(5 10 1 0 0 1 99 5 2) (werk "5,7,1,0,0,1,99,5,2")))))

(deftest test-equality-1
  (testing "should (equal '(6 1 1 5 99 1) (werk \"6,1,1,5,99,0\")) to be true"
    (ok (equal '(6 1 1 5 99 1) (werk "6,1,1,5,99,0")))))

(deftest test-if-else-1
  (testing "should (equal '(99) (werk \"55,12,0,13,6,10,1,0,0,16,2,0,0,16,99,55,0\")) to be true"

    (ok (equal '(99) (werk "99")))))
