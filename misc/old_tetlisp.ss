
(define (move-down shape-s board)
   (define color "red")
   (console.log "kk") (console.log shape-s)
   (\ shape-s map
      (lambda (x)
         (define sq-id (get-pix-id board (+ 1 (car x)) (cdr x)))
         (console.log "id:")
         (console.log sq-id)
         (set-pix-color sq-id color)
         (cons (+ 1 (car x)) (cdr x)))))
