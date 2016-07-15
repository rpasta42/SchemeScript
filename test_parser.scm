(load "helpers.scm")

;for generic helpers
;
(define (ir-store name val)
;   `(,(ir-tag 'assign) (,(ir-tag 'sym) ,name) ,(exp->ir val)))
   (list (ir-tag 'assign) (exp->ir name) val))

