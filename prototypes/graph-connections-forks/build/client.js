(function() {
  var SocketClient;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  SocketClient = require('websocket-client').WebSocket;
  module.exports.Client = (function() {
    __extends(Client, SocketClient);
    function Client(port, next, name) {
      this.port = port;
      if (name == null) {
        name = '';
      }
      this.log("Connecting to localhost:" + this.port);
      Client.__super__.constructor.call(this, "ws://localhost:" + this.port + "/" + name);
      this.on('open', __bind(function(sessionId) {
        next();
        return this.log("Websocket opened");
      }, this));
      this.on('close', function(sessionId) {
        return this.log("Websocket closed");
      });
      this.on('message', __bind(function(message) {
        return this.log("Got message: " + message);
      }, this));
    }
    Client.prototype.log = function(msg) {
      return console.log("[CLIENT:" + this.port + "] " + msg);
    };
    return Client;
  })();
}).call(this);
