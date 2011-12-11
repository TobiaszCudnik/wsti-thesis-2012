(function() {
  var Logger, Server, SocketServer, config;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  SocketServer = require("websocket-server").Server;
  config = require('../config');
  Logger = require('./logger');
  module.exports = Server = (function() {
    __extends(Server, SocketServer);
    function Server(port, next) {
      this.port = port;
      Server.__super__.constructor.call(this, {
        debug: config.debug
      });
      this.addListener('listening', next);
      this.addListener("connection", __bind(function(connection) {
        return this.log("Got new connection " + connection.id);
      }, this));
      this.addListener("disconnect", __bind(function(connection) {
        return this.log("Disconnected with " + connection.id);
      }, this));
      this.log("Binding to port " + this.port);
      this.listen(this.port);
    }
    Server.prototype.log = function(msg) {
      if (!Logger.log.apply(this, arguments)) {
        return;
      }
      return console.log("[SERVER:" + this.port + "] " + msg);
    };
    return Server;
  })();
}).call(this);
