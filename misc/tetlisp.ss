(tag div
   (style (padding-bottom 10px))
   "Hello, World! Welcome to tetplisp")

(tag div
   (attr (id "score")) (style (float right))
   "0 points")

(define exit false)
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
(define game-loop-counter 4000)
(define main-loop-delay 500) ;1000) ;5000) ;200)
(define current-shape null)
(define current-moves (new-arr)) ;can use it as hack for rotation
(define shapes-stable (new-arr)) ;not shapes, but just squares tbh
;(define (has-movement) )
;(define shapes-stored (new-arr))
(define keypress "none")
(define (get-pix-id pixels horiz vert) (arr-i (arr-i pixels horiz) vert))
(define (set-pix-color id color) (\ ($ id) css "background-color" color))

(define ok-fire true)

(define document.onkeypress
   (lambda (e)
      (define e (or e window.event))
      (define charCode (or e.charCode e.keyCode))
      (define keypress (String.fromCharCode charCode))
      (setTimeout (lambda () (define ok-fire true)) 1)

      (if (and ok-fire (= keypress "s")) ;okfire
         (step board) "")
      (define ok-fire false)
      (console.log "key pressed: ") (console.log keypress)))

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

(define (reset-board b)
   (for-each
      (range 0 num-cub-vert)
      (lambda (i row)
         (for-each
            (range 0 num-cub-hoz)
               (lambda (j col)
                  (set-pix-color (get-pix-id b row col) "gray"))))))

(define (new-board-squares)
   (for-each
      (range 0 num-cub-vert)
      (lambda (i row)
         (for-each
            (range 0 num-cub-hoz)
               (lambda (j col)
                  (new-cube "gray" row col))))))

;shape type =  "ziggy" | "square" | "line" | "tank" | "tankl" | "tankr"
(define (get-ziggy) (new-arr (cons 0 0) (cons 0 1) (cons 1 1) (cons 1 2)))
(define (get-square) (new-arr (cons 0 0) (cons 0 1) (cons 1 0) (cons 1 1)))
(define (get-line) (new-arr (cons 0 0) (cons 0 1) (cons 0 2) (cons 0 3)))
(define (_get-tank-bottom) (new-arr (cons 1 0) (cons 1 1) (cons 1 2)))
(define (get-tank)
   (define z (_get-tank-bottom))
   (\ z push (cons 1 0))
   z)
(define (get-tankl)
   (define z (_get-tank-bottom))
   (\ z push (cons 0 0))
   z)
(define (get-tankr)
   (define z (_get-tank-bottom))
   (\ z push (cons 2 0))
   z)

(define (get-new-shape type board-squares color) ;"red" by default
   (define shape-squares (new-arr))
   (if (= type "ziggy") (define shape-squares (get-ziggy)) "")
   (if (= type "square") (define shape-squares (get-square)) "")
   (if (= type "line") (define shape-squares (get-line)) "")
   (if (= type "tank") (define shape-squares (get-tank)) "")
   (if (= type "tankl") (define shape-squares (get-tankl)) "")
   (if (= type "tankr") (define shape-squares (get-tankr)) "")

   (console.log type)
   (console.log "shape squares:")
   (console.log shape-squares)

   (define shape-squares (\ shape-squares map (lambda (p) (cons (car p) (+ (cdr p) 3)))))

   (\ shape-squares map
      (lambda (x)
         ;(console.log (+ "first part:" (car x) "    second part:" (cdr x)))
         ;(console.log "board squares") (console.log board-squares)
         (define sq-id (get-pix-id board-squares (car x) (cdr x)))
         (console.log "id:")
         (console.log sq-id)
         (set-pix-color sq-id color)))
   shape-squares)

(define (new-board)
   (define board-squares (new-board-squares))
   board-squares)

(define (draw-stable b)
   (define points 0)

   (define rows (for-each (range 0 num-cub-vert) (lambda () (new-arr))))

   (\ shapes-stable map
      (lambda (p)
         (define row-index (car p))
         (arr-push (arr-i rows row-index) (cdr p))))

   ;(alert (JSON.stringify rows))
   (define shapes-stable-new (new-arr))
   ;(define num-skipped 0)
   (\ shapes-stable map
      (lambda (p)
         (define row-index (car p))
         (if (< (\ (arr-i rows row-index) length) 11)
            (arr-push shapes-stable-new p) "")))
            ;(arr-push shapes-stable-new (cons (+ num-skipped (car p)) (cdr p)))
            ;(define num-skipped (+ num-skipped 1)))))

   (define shapes-stable shapes-stable-new)

   ;(for-each rows
   ;   (lambda (i x) (if (> x.length 9) (alert (+ "big row" (String i))) "")))

   (\ shapes-stable map
      (lambda (p)
         (define points (+ points 1))
         (if (= (car p) 0) (begin (alert "you lost!") (define exit true)) "")
         (define sq-id (get-pix-id board (car p) (cdr p)))
         ;(console.log "id:")
         ;(console.log sq-id)
         (define color "red")
         (set-pix-color sq-id color)))
   (\ ($ "#score") html (+ (String points) " points")))

;(define (get-movement)
(define (process-moving-shape board)
   (if (= null current-shape) ""
      (process-moving-shape-not-null board)))

(define (process-moving-shape-not-null board)
   (define bad false)
   (arr-push current-moves keypress)
   (if (= keypress "q")
      (define current-shape (get-new-shape shape-type board "red")) "")

   (define (get-testpoints usekey)
      (define ret
         (\ current-shape map
            (lambda (p)
               (define x (+ 1 (car p))) (define y (cdr p))
               (if (! usekey) ""
                  (begin
                     (if (= keypress "a") (define y (- y 1)) "")
                     (if (= keypress "d") (define y (+ y 1)) "")
                     ;(if (= keypress "s") (define x (+ x 1)) "")
                     (if (= keypress "q")
                        (begin (define tmp x) (define x y) (define y tmp)) "")))
               (cons x y))))
      ret)


   (define (test-bad)
      (\ testpoints map
         (lambda (p)
            (define x (car p))
            (define y (cdr p))
            (if (or (< x 0) (< y 0) (> y num-cub-hoz) (> x num-cub-vert)) ;(> x num-cub-hoz) (> y num-cub-vert))
               (define bad true) "")

            (\ shapes-stable map
               (lambda (p2)
                  (if (and (= (car p2) x) (= (cdr p2) y))
                     (define bad true)
                     ""))))))

   (define testpoints (get-testpoints true))
   (test-bad)

   (if bad
      (begin
         (define testpoints (get-testpoints false))
         (define bad false)
         (test-bad))
      "")

   (define colors (new-arr "#3cc7d6" "#fbb414" "#e84138" "#3993d0"))
   (define color (arr-i colors (Math.floor (* (Math.random) colors.length))))

   (if bad
      (begin
         (\ current-shape map
            (lambda (p) (arr-push shapes-stable p)))
         (define current-shape null))
      (begin
         (define current-shape testpoints)
         (\ current-shape map
            (lambda (p)
               (define sq-id (get-pix-id board (car p) (cdr p)))
               (set-pix-color sq-id color))))))

(define (step b)
   (define z (- 1000 game-loop-counter))
   (console.log z)
   (reset-board b)
   (process-moving-shape b)
   (draw-stable b)

   ;(new-cube "#ff0000" z z)
   ;(define shapes-stored
   ;(define shapes-stored
   ;   (for-each shapes-stored
   ;             (lambda (i shape-s)
   ;               ;(console.log "before moved:") (console.log shape-s)
   ;               (define x (move-down shape-s b))
   ;               ;(console.log "after moved:") (console.log x)
   ;               x)))

   (define shape-types (new-arr "ziggy" "square" "line" "tank" "tankl" "tankr"))
   (define shape-type (arr-i shape-types (Math.floor (* (Math.random) (- shape-types.length 1)))))
   (console.log (+ "shape: " shape-type))
   ;(define counter555 (+ counter555 1))

   ;(if (> counter555 5)
   ;   (begin
   ;      (arr-push shapes-stored (get-new-shape shape-type b "red"))
   ;      (define current-shape (get-new-shape shape-type b "red"))
   ;      (define counter555 0))
   ;   (define counter555 (+ counter555 1))))
   (if (! (= current-shape null)) ""
      (define current-shape (get-new-shape shape-type b "red"))))

(define (game-loop b)
   (console.log "i")
   (define kdelay main-loop-delay)
   (if (= keypress "s") (define kdelay 1) "")

   (if (and (> game-loop-counter 0) (! exit))
      (begin
         (define game-loop-counter (- game-loop-counter 1))
         (step b)
         (define keypress "none")
         ;(define n (- n 2))
         ;(\ ($ "#square") css "left" (+ "" (- 1000 n) "px"))
         ;(setTimeout game-loop main-loop-delay b))
         (setTimeout (lambda () (game-loop b)) kdelay))
       ""))

(define (main)
   (define board (new-board)) ;game grid
   (game-loop board))

(main)

