(function() {
  var io;
  io = require("socket.io-client/socket.io").io;
  module.exports.Client = (function() {
    function Client(port, next, name) {
      if (name == null) {
        name = '';
      }
      this.socket = new io.Socket('localhost', {
        port: port
      });
      this.socket.connect();
      this.socket.on('connect', function() {
        console.log("connected " + port);
        return next();
      });
      this.socket.on('message', function(data) {
        return console.log("Message " + data);
      });
    }
    Client.prototype.send = function(msg) {
      return this.socket.send(msg);
    };
    return Client;
  })();
}).call(this);
