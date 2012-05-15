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
	
	node = link = null
																																																																																																																															  
	d3.json "data.json", (json) ->
		data = json
		
		# Construct the graph.
		force.nodes(json.nodes).links(json.links).start()
												
		# Setup links.
		link = svg.selectAll("line.link")
			.data(json.links)
		
		link.enter()
			.append("line")
				.attr("class", "link")
				.style("stroke-width", (d) ->
					Math.sqrt d.value
				)
		
		link.exit()
			.remove()
									
		# Setup nodes.
		node = svg
			.selectAll("circle.node")
			.data(json.nodes)
		
		node.enter()
			.append("circle")
				.attr("class", "node")
				.attr("r", 5)
				.style("fill", (d) ->
					color d.group or 0
				)
				.call(force.drag)
		
		node.exit().remove()
											
		# TODO not working?
		node.append("title").text (d) ->
			d.name

		# Handle animations.
		force.on "tick", ->
			
			node
				.attr("cx", (d) -> d.x)
				.attr "cy", (d) -> d.y
				
			link
				.attr("x1", (d) -> d.source.x)
				.attr("y1", (d) -> d.source.y)
				.attr("x2", (d) -> d.target.x)
				.attr("y2", (d) -> d.target.y)
																																																																
	testAdd = ->
		id = Math.ceil(Math.random() * 100)
		index = data.nodes.push
			name: "TEST #{id}"
			group: 1
			
		# link to random node
		index--
		target = Math.ceil(Math.random() * 100) % (data.nodes.length-1)
		weight = Math.ceil(Math.random() * 100) % 5
		new_link =
			source: data.nodes[ index ]
			target: data.nodes[ target ]
			value: weight
	
		data.links.push new_link
	
		# update nodes
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
		
		# update links
		svg
			.selectAll("line.link")
			.data(data.links)
			.enter()
				.append("line")
					.attr("class", "link")
					.style("stroke-width", (d) ->
						Math.sqrt d.value
					)
						
		force.start()
		
		null
			
	testRemove = ->
		data.nodes.pop()
		removed_index = data.nodes.length
		
		data.links = data.links.filter (v) ->
			v.source.index isnt removed_index and
				v.target.index isnt removed_index
	
		svg
			.selectAll('circle.node')
			.data(data.nodes)
	#		.exit()
	#			.remove()
	
		svg
			.selectAll('line.link')
			.data(data.links)
	#		.exit()
	#			.remove()
		
		# update internal reference
		force.links data.links
										
		force.start()
		
		null
				
	# Exports.
	window.testAdd = testAdd
	window.testRemove = testRemove

