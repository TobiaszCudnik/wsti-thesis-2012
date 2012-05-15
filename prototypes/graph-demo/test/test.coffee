window.svg = svg = d3.select("#graph")
data = [
	{"x": 1.0, "y": 1.5}, {"x": 2.0, "y": 2.5}
]

window.data2 = data2 = [
	{"x": 2.0, "y": 2.5}, {"x": 3.0, "y": 3.5}
]

window.draw = draw = (data) ->
	circle = svg.selectAll("circle")
		.data(data)

	circle.enter()
		.append("circle").attr "r", 2.5

	circle
		.transition().duration(1000).ease("exp-in-out")
		.attr("cx", (d) -> d.x * 10)
		.attr "cy", (d) -> d.y * 10

	circle.exit()
		.transition().duration(1000).ease("exp-in-out")
		.remove()

draw data
window.test = ->
	draw data
window.test2 = ->
	draw data2