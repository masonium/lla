;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :lla-tests)

;; SUPPORT FUNCTIONS

;; support functions

(defun array= (array1 array2)
  "Test that arrays are equal and have the same element type."
  (and (type= (array-element-type array1)
              (array-element-type array2))
       (equalp array1 array2)))

(defun random-array (type &rest dimensions)
  "Random array for testing."
  (aops:generate dimensions (if (subtypep type 'complex)
                                (lambda () (coerce (complex (random 100)
                                                            (random 100))
                                                   type))
                                (lambda () (coerce (random 100) type))) type))

(defmacro with-foreign-temporary-buffer ((pointer size) &body body)
    "Allocate a buffer for SIZE complex doubles."
    `(with-foreign-pointer (,pointer (* ,size (foreign-type-size :double) 2))
       ,@body))

(defparameter *allowed-difference* 1d-5
  ;; default is for catching major mistakes, use smaller value for fine points
  "Maximum allowed difference used by approx=.")

;; (defun make-vector-with-seq (n lla-type)
;;   "Return a numeric-vector of type LLA-TYPE, holding the integers 0...n-1."
;;   (aprog1 (lla-array n lla-type)
;;     (dotimes (index n)
;;       (setf (aref it index) (coerce* index lla-type)))))

;; (defun make-matrix-with-seq (nrow ncol lla-type)
;;   "Return a dense matrix of type LLA-TYPE, holding the integers
;; 0...n-1 in column-major order."
;;   (lla::make-matrix% nrow ncol (make-vector-with-seq (* nrow ncol) lla-type)))

(deftestsuite utilities-tests (lla-tests)
  ())

(addtest (utilities-tests)
  approx=-test
  (let ((*num=-tolerance* 1))
    (ensure (num= 0 10))
    (ensure (not (num= -1 10)))))

(addtest (utilities-tests)
  num=-test
  (let ((*lift-equality-test* #'num=))
    (ensure-same (dense t 1) (dense t 1))
    (ensure-different (dense t 1) (dense t 2))))

;; (addtest (utilities-tests)
;;   make-vector-or-matrix-test
;;   (let ((*lift-equality-test* #'num=))
;;     (ensure-same (make-vector-with-seq 3 :single) (clo :single 0 1 2))
;;     (ensure-same (make-matrix-with-seq 2 2 :complex-double)
;;                  (clo :complex-double
;;                       0 2 :/
;;                       1 3))))
