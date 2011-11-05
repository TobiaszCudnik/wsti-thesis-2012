(function() {
  var Client, Server, clients, connections, flow, name, node, nodes, schema, sys, _i, _len;
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
  for (name in schema) {
    clients = schema[name];
    nodes[name] = new Server("800" + name);
    connections[name] = {};
    for (_i = 0, _len = clients.length; _i < _len; _i++) {
      node = clients[_i];
      connections[name][node] = new Client("800" + node);
    }
  }
  console.log(sys.inspect(nodes));
  console.log(sys.inspect(connections));
  debugger;
  connections[1][2].send('foo');
  connections[1][1].send('foo');
  setTimeout(function() {
    return console.log('exit');
  }, 5000);
  console.log('Finished WebSocket proto.coffee');
}).call(this);
