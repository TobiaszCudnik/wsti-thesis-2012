(function() {
  var Logger, Server, config, dnode;
  dnode = require('dnode');
  config = require('../config');
  Logger = require('./logger');
  module.exports = Server = (function() {
    Server.prototype.dnode = null;
    function Server(port, scope, next) {
      this.port = port;
      this.dnode = dnode(scope);
      this.dnode.listen(this.port);
      this.log("Binding to port " + this.port);
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
