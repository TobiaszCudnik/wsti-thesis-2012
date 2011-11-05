(function() {
  var SocketServer;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  SocketServer = require("websocket-server").Server;
  module.exports.Server = (function() {
    __extends(Server, SocketServer);
    function Server(port) {
      Server.__super__.constructor.call(this);
      this.addListener("connection", function(connection) {
        return connection.addListener("message", function(msg) {
          console.log("Server " + port + " received message");
          return server.send(msg);
        });
      });
      console.log("Server listening on " + port);
      this.listen(port);
    }
    return Server;
  })();
}).call(this);
