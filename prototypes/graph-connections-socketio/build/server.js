(function() {
  var io;
  io = require('socket.io');
  module.exports.Server = (function() {
    function Server(port, next) {
      this.server = require('http').createServer(function() {});
      this.io = io.listen(this.server);
      this.server.listen(port);
      this.io.sockets.on('connection', function(socket) {
        socket.emit('news', {
          hello: 'world'
        });
        return console.log('server connection');
      });
      next();
    }
    return Server;
  })();
}).call(this);
