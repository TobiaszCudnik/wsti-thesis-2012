(function() {
  var Client, Server, connections, flow, nodes, schema, sys;
  Server = require('./server').Server;
  Client = require('./client').Client;
  flow = require('flow');
  sys = require('sys');
  console.log('Web socket prototype starting...');
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
    return connections[1] = {
      2: new Client("8001", this)
    };
  }, function() {
    console.log('All clients connected');
    connections[1][2].send('foo');
    return console.log('Test data sent');
  });
  console.log('Finished WebSocket proto.coffee');
}).call(this);
