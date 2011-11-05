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
    function Client(port, name) {
      if (name == null) {
        name = '';
      }
      console.log("module.exports.Client " + name + port);
      Client.__super__.constructor.call(this, "ws://localhost:" + port + "/" + name, "" + name + port);
      this.on('open', __bind(function(sessionId) {
        console.log("Websocket open with session id: " + sessionId);
        return this.send('This is a test message');
      }, this));
      this.on('close', function(sessionId) {
        return console.log("Websocket closed with session id: " + sessionId);
      });
      this.on('message', __bind(function(message) {
        console.log("Got message: " + message);
        return this.close();
      }, this));
    }
    return Client;
  })();
}).call(this);
