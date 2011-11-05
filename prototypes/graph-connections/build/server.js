(function() {
  var SocketServer;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  SocketServer = require("websocket-server").Server;
  module.exports.Server = (function() {
    __extends(Server, SocketServer);
    function Server(port, next) {
      Server.__super__.constructor.call(this);
      this.addListener('listening', next);
      this.addListener("connection", __bind(function(connection) {
        return connection.addListener("message", __bind(function(msg) {
          console.log("Server " + port + " received message");
          return this.send(msg);
        }, this));
      }, this));
      console.log("Server listening on " + port);
      this.listen(port);
    }
    return Server;
  })();
}).call(this);
