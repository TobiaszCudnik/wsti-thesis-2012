(function() {
  module.exports.Node = (function() {
    function Node(client_sockets, server_sockets, services) {
      this.client_sockets = client_sockets;
      this.server_sockets = server_sockets;
      this.services = services;
    }
    return Node;
  })();
}).call(this);
