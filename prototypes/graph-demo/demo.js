(function() {
  var link, node, svg;

  node = null;

  link = null;

  svg = null;

  window.node = node;

  window.link = link;

  window.svg = svg;

  $(function() {
    var color, force, height, width;
    width = 960;
    height = 500;
    color = d3.scale.category20();
    force = d3.layout.force().charge(-120).linkDistance(30).size([width, height]);
    svg = d3.select("#graph").append("svg").attr("width", width).attr("height", height);
    return d3.json("data.json", function(json) {
      force.nodes(json.nodes).links(json.links).start();
      link = svg.selectAll("line.link").data(json.links).enter().append("line").attr("class", "link").style("stroke-width", function(d) {
        return Math.sqrt(d.value);
      });
      node = svg.selectAll("circle.node").data(json.nodes).enter().append("circle").attr("class", "node").attr("r", 5).style("fill", function(d) {
        return color(d.group);
      }).call(force.drag);
      node.append("title").text(function(d) {
        return d.name;
      });
      return force.on("tick", function() {
        link.attr("x1", function(d) {
          return d.source.x;
        }).attr("y1", function(d) {
          return d.source.y;
        }).attr("x2", function(d) {
          return d.target.x;
        }).attr("y2", function(d) {
          return d.target.y;
        });
        return node.attr("cx", function(d) {
          return d.x;
        }).attr("cy", function(d) {
          return d.y;
        });
      });
    });
  });

}).call(this);
