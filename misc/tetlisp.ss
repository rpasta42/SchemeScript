
;(define (ha) (alert "yo"))

;(tag button
;   (attr (onclick "ha()"))
;   "click me")

;(define x 5)
;(alert x)
;(define f (lambda (a b c) (+ a b c)))
;(define (f a b c) (+ a b c))
;(f 3 2 5)

(define (repeat-str s n)
   (if (> n 0)
      (+ s (repeat-str s (- n 1)))
      ""))

;(alert (repeat-str "hello" 10))

(define big-space
   (repeat-str
      (+ (repeat-str "&nbsp;" 10) "</br>")
      10))

(tag div
   (style
      (width 15el) (height 15el)
      (position absolute)
      (overflow hidden)
      (background-color black))
   (attr (id "square")))
   ;,big-space)
   ;"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</br>&nbsp;&nbsp;")


( \ ($ ".square") call html)

(tag br) (tag br)
;(alert "welcome to tetlisp")
(tag div "hi")
(tag div "hello world")

;(setTimeout (lambda () (alert "hi")) 1000)

(tag div
   "fdsfdsf"
   (style
      (padding-top 10px)
      (background-color red)))

(tag
   img
   (attr
      (src "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRuNefA8D7pLxMK0Iwxz-yTSxPctp1emAIBNKoIVXg4ZZkZqN9t")))
