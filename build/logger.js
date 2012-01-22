(function() {
  var Logger, config;
  config = require('../config');
  module.exports = Logger = (function() {
    function Logger() {}
    Logger.log = function() {
      if (!config.debug) {
        return false;
      }
      return (config.log != null) && config.log.push(msg);
    };
    return Logger;
  })();
}).call(this);
