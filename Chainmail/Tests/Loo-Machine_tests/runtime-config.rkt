#lang racket
(require redex)
(require "../../Loo.rkt")

(provide test-runtimeConfig)

(define (test-runtimeConfig)
  
  (display "-------------------------------------")
  (display "\nRunning Runtime Config Tests:\n")

  (define Machine_runtime-config? (redex-match? Loo-Machine σ))

  (define true_runtime-configs (list
                                (term ((() mt) mt))   ;;empty stack, empty heap
                                (term ((() mt) (mt [1 -> (C1 (mt [f1 -> 10]))])))  ;;empty stack
                                (term ((((x1 @ f1 := x2) mt) · (() mt)) mt)) ;;empty heap
                                (term (((x := * $ ()) mt) mt))  ;;continuation
                                (term (((x := * $ ()) mt) (mt [0 -> (C mt)])))
                                (term (((x := * $ ()) mt) ((mt [0 -> (C mt)]) [1 -> (C mt)])))
                                (term (((x := * $ ()) mt) (((mt [0 -> (C mt)]) [1 -> (C mt)]) [2 -> (C mt)])))
                                (term (((() ((mt [x1 -> 10]) [x2 -> 20])) · ((x := * $ (x2 := x4 @ mtd())) ((mt [x1 -> 10]) [x2 -> 20]))) ((mt [1 -> (C1 (mt [f1 -> 10]))]) [2 -> (C2 (mt [f2 -> 100]))]))) 
                                ))

  (define false_runtime-configs (list
                                 (term ((() (mt)) mt))   ;;brackets around mt in stack
                                 (term ((() mt) (mt)))   ;;brackets around mt in heap
                                 (term ((((x1 @ f1 := x2) (mt)) · (() mt)) mt)) ;;invalid stack
                                 (term ((() mt) ([1 -> (C1 (mt [f1 -> 10]))] [2 -> (C1 (mt [f1 -> 30]))])))  ;;invalid heap, bracketing
                                 (term ((() mt) (() mt) mt))  ;;more than one stack
                                 ))

  (for ([runtime-configs true_runtime-configs])
    (test-equal (Machine_runtime-config? runtime-configs) #true))

  (for ([runtime-configs false_runtime-configs])
    (test-equal (Machine_runtime-config? runtime-configs) #false))

  (test-results)

  (display "-------------------------------------")
  )