//npm install express
//npm install --save body-parser
var fs = require('fs');
var express = require('express');
var app = express();

var bodyParser = require('body-parser');
app.use(bodyParser.json());
/*app.use(bodyParser.urlencoded({
   extended: true
}));*/
var miscutils = require('../common.js');

//INIT (when server re-starts)
//0 = none/fatal (don't do this). 1 = normal logging. 2 = debug logs
var debugSrv = 1;
var dataDir = '../data/';

if (debugSrv >= 1)
   console.log('==server restart');
//end INIT

//global callbacks
function onErr(err) {
   if (err) console.log(err);
}
function onReq(req, res) {
   if (debugSrv >= 1)
      console.log('request: ' + req.sessionID);
   res.set('Access-Control-Allow-Origin', '*');
   return req.query;
}
function reqReturn(res, response) {
   //res.send(200, response);
   res.status(200).send(response);
}
//end global callbacks

///REQUEST HANDLERS
//[{'title':x, 'tags':[x], 'data':'x', 'date':'x'}]
function getBlogPosts() {
   var postFileNames = fs.readdirSync(dataDir);
   var posts = [];

   for (postDate in postFileNames) {
      var postStr = fs.readFileSync(dataDir + postFileNames[postDate]);
      var postJson = JSON.parse(postStr); //JSON.stringify()
      var date = postFileNames[postDate].substring(4);
      postJson['date'] = date;
      posts.push(postJson);
      if (debugSrv >= 2)
         console.log(postJson);
   }
   return posts;
}

// returns [{'name':x, 'count':x}]
function getTagCounts() {
   var postList = getBlogPosts();
   var tagCounts = {};

   for (i in postList) {
      var post = postList[i];
      var postTags = post['tags'];
      for (i in postTags) {
         var tagName = postTags[i];
         if (tagCounts[tagName] == undefined)
            tagCounts[tagName] = 1;
         else tagCounts[tagName] += 1;
      }
   }
   return tagCounts;
}


function truncatePostForPreview(entryContent) {
   var numWords = 20;
   var maxChars = 80;
   var truncated = entryContent.substring(0, maxChars);
   var splitted = truncated.split(' ');

   var previewArr = splitted.slice(0, numWords);
   var preview = previewArr.join(' ');
   return preview;
}

//[{'title':x, 'tags':[x], 'data':preview, 'date':'x'}]
function getPreviewList(pageNum, sortReverse, sortType) {
   var postList = getBlogPosts();

   var sortedPosts = miscutils.sort(postList, (posta, postb) => {
      var d1 = posta['date'], d2 = postb['date'];
      if (d1 == d2) return 0;
      if (d1 < d2) return 1;
      if (d1 > d2) return 2;
   });
   //for (x in sortedPosts)
   //   alert(formatPostDate(sortedPosts[x]));
   //
   // var postsDates = map(postList, (post) => post['date']);
   // var sortedDates = sort(postsDates, cmpNums);
   // return sortedDates;

   for (x in sortedPosts) {
      var post = sortedPosts[x];
      sortedPosts[x].data = truncatePostForPreview(post.data);
   }
   return sortedPosts;
}

///END REQUEST HANDLERS

app.get('/ira/blogEntry', function(req, res) {
   var query = onReq(req, res);
   var postDate = query.page;

   var postPath = dataDir + '/post' + postDate;
   var postJson = JSON.parse(fs.readFileSync(postPath));
   var postHtml = postJson.data;
   var response = postHtml;
   //var response = 'hello';
   reqReturn(res, response);
});

app.get('/ira/serv', function(req, res) {
   var query = onReq(req, res);

   //console.log(req);
   //console.log(query);
   console.log('query: ' + JSON.stringify(query));
   var response = null;

   if (query.data == 'getBlogPosts') {
      var posts = getBlogPosts();
      response = posts;
   }
   else if (query.data == 'getTagCounts') {
      var tags = getTagCounts();
      response = tags;
   }
   else if (query.data == 'getPreviews') {
      var pageNum = query.page;
      var sortReverse = query.sortReverse;
      var sortType = query.sortType;
      var previewList = getPreviewList(pageNum, sortReverse, sortType);
      response = previewList;
   }
   else if (query.data == 'getBlogPostByDate') {

   }
   else if (query.action == 'uploadBlogPost') {
      var post = {
         'title'  : query.title,
         'tags'   : JSON.parse(query.tags),
         'data'   : query.data
      };
      var postData = JSON.stringify(post);
      var date = Date.now(); //new Date;
      var fName = dataDir + 'post' + date;
      fs.writeFile(fName, postData);

      console.log('Uploading new blog');
   }
   reqReturn(res, response);
});


app.post('/ira/serv', function(req, res) {
   /*console.log('request: ' + req.sessionID);
   console.log(req.body);
   fs.writeFile('/tmp/test', req.body, onErr);*/
});

app.listen(1342);


