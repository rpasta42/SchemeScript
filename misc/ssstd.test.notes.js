//(alert (\ dict_tester ha))
var dict_tester = {
   'ha' : 3,
   'blah' : [1, 2, 3],
}
var test_obj = {
   type: 'blah',
   test : function() { alert('ha'); alert(this.type); },
   test2 : function(a) { alert(a + this.type); }
}

/*scm_obj_dict()
(\ test_obj test call)
(\ test_obj test set newval)

(: (a 1) (b 2)) == (dict (a 1) (b 2)) == { a: 1, b:2 }
(arr a b c) = [a, b, c]*/

//broken, see this: https://github.com/ariya/phantomjs/issues/10518
function phantom_screenshot(url, filename) {
   var page = require('webpage').create();
   page.open(url, function() {
      page.render(filename);
      phantom.exit();
   });
}

/*
(define my-pic (tag img (src "test.png")))

;TODO: should attr's (style, id, class) be in a list?
;TODO: should children be in a list or by themselves?
;TODO: should style be attr or it's own property?

;winner!! good
(define my-pic (tag img (attr (src "test.png"))))

(attr (src "blah") (test "da")) = (attr src "blah") (attr test "da")
(style background-color red) (style border-radius 10) = (style (background-color red) (border-radius 10))

(tag (div "ha") (ref mypic)) = (tag div "ha") (ref mypic)

(tag div
     (attr (color red) (id "yo") (class "hi"))
     (style (background-color red) (border-radius 10))
     (tag h1 "hello")
     (tag a "ha")
     (ref mypic))

;more winrar examples
(define ss (style ...))
(tag div
     (ref ss) ;set style from variable
     (style (text-size 10))) ;add more style manually
;end winrar

(tag a
     (style ())
     (attr ())
     (tag h1 "blah"))

;bad
(tag (name div)
     (style (background-color red))
     (attr (id "yo") (class "ha"))
     (children (tag (name "ha"))))

(tag
   div
   (attr
      (style (border-radius 10) (background-color red))
      (color red)
      (id "yo")
      (class "yo"))
   ((tag a "test")
    (tag h1 "yolo")
    (ref my-pic)))

(div
   (style
      (border-radius 10)
      (color red))
   (id "test")
   (class "yo")
   ((tag a "test") ;last array/element is always content
    (tag h1 "yolo")
    (ref my-pic)) ;ref = reference to different element
*/

