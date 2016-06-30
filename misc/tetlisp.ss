(tag div
   (style (padding-bottom 10px))
   "Hello, World! Welcome to tetplisp")

(define rand-str-ctr 0)
(define (rand-str)
   (define new-str (+ "tmp" (String rand-str-ctr)))
   (define rand-str-ctr (+ rand-str-ctr 1))
   new-str)

;(define (ha) (alert "yo"))
;(tag button (attr (onclick "ha()")) "click me")

(define (repeat-str s n) (if (> n 0) (+ s (repeat-str s (- n 1))) ""))
(define big-space (repeat-str "&nbsp;" 3000))

;TODO: calculate width and height dynamically
(define cube-width 30)
(define cube-height 30)
(define num-cub-hoz 10)
(define num-cub-vert 20)
(define game-loop-counter 1000)
(define main-loop-delay 4000) ;10000) ;5000) ;200)


(tag
   div
   (attr (id "board"))
   (style (width 300px) (height 600px))
   (tag div
      (style
         (width 30px) (height 30px)
         ;(display none)
         (position absolute)
         (overflow hidden)
         (background-color black))
      (attr (id "firstsquare"))))

(\ ($ "#firstsquare") html big-space)
(define first-style (\ ($ "#firstsquare") attr "style"))
(\ ($ "#firstsquare") css "display" "none")

;(ref big-space)))
;,big-space)
;"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</br>&nbsp;&nbsp;")
;(get-rect-html)

(define (new-cube color top left)
   (define id (rand-str))

   (define code (+ "<div id='" id "' class='sq'>" big-space "</div>"))
   (define id (+ "#" id))
   (define x (\ ($ "#board") append code))
   ;(alert first-style)
   ;(\ ($ ".sq") attr "style" first-style)
   ;(\ ($ x) attr call "style" first-style)
   (\ ($ id) attr "style" first-style)
   (\ ($ id) css "top" (+ (String (* cube-height top)) "px"))
   (\ ($ id) css "left" (+ (String (* cube-width left)) "px"))
   (\ ($ id) css "background-color" color)
   id)

(define (new-board-squares)
   (for-each
      (range 0 num-cub-vert)
      (lambda (i row)
         (for-each
            (range 0 num-cub-hoz)
               (lambda (j col)
                  (new-cube "gray" row col))))))

;shape type =  "ziggy" | "cube" | "line" | "tank" | "tankl" | "tankr"
(define (get-ziggy) (new-arr (cons 0 0) (cons 0 1) (cons 1 1) (cons 1 2)))
(define (get-square) (new-arr (cons 0 0) (cons 0 1) (cons 1 0) (cons 1 1)))
(define (get-line) (new-arr (cons 0 0) (cons 0 1) (cons 0 2) (cons 0 3)))
(define (_get-tank-bottom) (new-arr (cons 1 0) (cons 1 1) (cons 1 2)))
(define (get-tank) (\ (_get-tank-bottom) push (cons 1 0)))
(define (get-tank-l) (\ (_get-tank-buttom) push (cons 0 0)))
(define (get-tank-r) (\ (_get-tank-buttom) push (cons 2 0)))


(define (get-pix-id pixels horiz vert)
   ;(arr-i pixels (+ (* vert num-cub-hoz) horiz)))
   (arr-i (arr-i pixels horiz) vert))

(define (set-pix-color id color)
   (\ ($ id) css "background-color" color))

(define (get-new-shape type board-squares)
   ;(define s (new-dict))

   (define squares
      (if (= type "ziggy") (get-ziggy)
      (if (= type "square") (get-square)
      (if (= type "line") (get-line)
      (if (= type "tank") (get-tank)
      (if (= type "tankl") (get-tankl)
      (if (= type "tankr") (get-tankr)
         "bad squares")))))))

   (console.log type)
   (console.log squares)

   (\ squares map
      (lambda (x)
         (define sq-id (get-pix-id board-squares (car x) (cdr x)))
         (console.log sq-id)
         (set-pix-color sq-id "red"))))

(define (new-board)
   (define board-squares (new-board-squares))
   (get-new-shape "ziggy" board-squares)
   squares)

(define (step b)
   (define z (- 1000 game-loop-counter))
   (console.log z)
   (new-cube "#ff0000" z z))

(define (game-loop)
   (console.log "i")
   (if (> game-loop-counter 0)
      (begin
         (define game-loop-counter (- game-loop-counter 1))
         ;(step board)

         ;(define n (- n 2))
         ;(\ ($ "#square") css "left" (+ "" (- 1000 n) "px"))
         (setTimeout game-loop main-loop-delay))
       ""))

;(f)


;(setTimeout (lambda () (alert "hi")) 1000)
;(tag div "fdsfdsf" (style (padding-top 10px) (background-color red)))

(define (main)
   (define board (new-board)) ;game grid
   ;(alert board)
   (game-loop board))

(main)
