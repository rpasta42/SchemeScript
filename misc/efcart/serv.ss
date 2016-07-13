;npm install express
;npm install --save body-parser

(define fs (require "fs"))
;(define express (require "express"))

;(define app (express))

;(define bodyParser (require "body-parser"))
;(app.use (bodyParser.json))

(define miscutils (require "./common.js"))

(define debug 1)
(define dataDir "data/")

(define (onErr err)
   ;(if err (console.log err) '()))
   (if err (console.log err) null))

(define (onReq req res)
   (res.set "Access-Control-Allow-Origin", "*")
   req.query)

(define (reqReturn res response)
   (\ (res.status 200) send response))


(define (getFluidList)
   (define fluidFileNames (fs.readdirSync dataDir))
   (define fluids (new_arr))
   (for_each fluidFileNames
             (lambda (i item) (fluids.push item)))
   (console.log fluids))

(getFluidList)


