data = null
width = 500
height = 300
color = d3.scale.category20()
force = d3.layout
	.force()
	.charge(-120)
	.linkDistance(30)
	.size([ width, height ])

$ ->			  
	svg = d3.select("#graph")
		.append("svg")
			.attr("width", width)
			.attr("height", height)
																															  
	d3.json "data.json", (json) ->
		data = json
		# START
		force.nodes(json.nodes).links(json.links).start()
																																
		link = svg
			.selectAll("line.link")
			.data(json.links)
			.enter()
				.append("line")
					.attr("class", "link")
					.style("stroke-width", (d) ->
						Math.sqrt d.value
					)
																										    
		node = svg
			.selectAll("circle.node")
			.data(json.nodes)
			.enter()
				.append("circle")
					.attr("class", "node")
					.attr("r", 5)
					.style("fill", (d) ->
						color d.group or 0
					)
					.call(force.drag)

#		node.exit().remove()
																																																														    
		node.append("title").text (d) ->
			d.name

		# UPDATE
		force.on "tick", ->
			svg.selectAll("circle.node")
				.attr("cx", (d) -> d.x)
				.attr "cy", (d) -> d.y
			link
				.attr("x1", (d) -> d.source.x)
				.attr("y1", (d) -> d.source.y)
				.attr("x2", (d) -> d.target.x)
				.attr("y2", (d) -> d.target.y)

																																																																
		# global refs
		window.node = node
#		window.link = link
		window.svg = svg
																
testAdd = ->
	index = data.nodes.push
		name: 'TEST 1'
		group: 1
				
	# link to first node
	index--
	data.links.push
		source: index
		target: 0
		value: 1
		
	svg
		.selectAll('circle.node')
		.data(data.nodes)
		.enter()
			.append("circle")
				.attr("class", "node")
				.attr("r", 5)
				.style("fill", (d) ->
					color d.group or 0
				)
		
	force.start()
	
testRemove = ->
	data.nodes.pop()
	
	svg
		.selectAll('circle.node')
		.data(data.nodes)
		.exit()
			.remove()
		
	force.start()
	
window.testAdd = testAdd
window.testRemove = testRemove