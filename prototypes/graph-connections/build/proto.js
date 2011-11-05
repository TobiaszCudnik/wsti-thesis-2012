(function() {
  var Client, Server, connections, flow, nodes, schema, sys;
  Server = require('./server').Server;
  Client = require('./client').Client;
  flow = require('flow');
  sys = require('sys');
  console.log('Web sockete prototype starting...');
  schema = {
    1: [2, 3],
    2: [1],
    3: [2],
    4: [2, 3]
  };
  nodes = {};
  connections = {};
  flow.exec(function() {
    var clients, server, _results;
    _results = [];
    for (server in schema) {
      clients = schema[server];
      _results.push(nodes[server] = new Server("800" + server, this.MULTI()));
    }
    return _results;
  }, function() {
    var client, clients, server, _results;
    _results = [];
    for (server in schema) {
      clients = schema[server];
      connections[server] = {};
      _results.push((function() {
        var _i, _len, _results2;
        _results2 = [];
        for (_i = 0, _len = clients.length; _i < _len; _i++) {
          client = clients[_i];
          _results2.push(connections[server][client] = new Client("800" + server, this.MULTI()));
        }
        return _results2;
      }).call(this));
    }
    return _results;
  }, function() {
    console.log('All clients connected');
    connections[1][2].send('foo');
    return console.log('Test data sent');
  });
  console.log('Finished WebSocket proto.coffee');
}).call(this);
