var express = require('express');
var app = express();
var path = require('path');

app.use(express.static(path.resolve('public')));
app.get('/', function(req, res) {
  res.sendfile(path.resolve('public', 'index.html'));
});

app.listen(8080);
console.log("Breakout server has started, access it at http://localhost:8080/");
console.log("Close this window to stop the server, or press Ctrl+C.");
