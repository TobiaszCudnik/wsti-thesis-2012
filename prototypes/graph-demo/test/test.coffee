window.svg = svg = d3.select("#graph")
data = [
	{"x": 1.0, "y": 1.5}, {"x": 2.0, "y": 2.5}
]

window.data2 = data2 = [
	{"x": 2.0, "y": 2.5}, {"x": 3.0, "y": 3.5}
]

circle = svg.selectAll("circle")
	.data(data)

circle.enter()
	.append("circle").attr "r", 2.5

circle
	.attr("cx", (d) -> d.x * 10)
	.attr "cy", (d) -> d.y * 10

circle.exit()
	.remove()