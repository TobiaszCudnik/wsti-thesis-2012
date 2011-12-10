(function() {
  var SocketServer, http;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  SocketServer = require("websocket-server").Server;
  http = require('http');
  module.exports.Server = (function() {
    __extends(Server, SocketServer);
    Server.prototype.debug = true;
    function Server(port, next) {
      this.port = port;
      this.server = http.createServer();
      Server.__super__.constructor.call(this, {
        server: this.server,
        debug: this.debug
      });
      this.addListener('listening', next);
      this.addListener("connection", __bind(function(connection) {
        this.log("Got new connection " + connection.id);
        return connection.addListener("message", __bind(function(message) {
          this.log("Got message: " + message);
          return this.send(connection.id, message);
        }, this));
      }, this));
      this.addListener("disconnect", __bind(function(connection) {
        return this.log("Disconnected with " + connection.id);
      }, this));
      this.log("Listening on " + this.port);
      this.listen(this.port);
    }
    Server.prototype.log = function(msg) {
      return console.log("[SERVER:" + this.port + "] " + msg);
    };
    return Server;
  })();
}).call(this);
