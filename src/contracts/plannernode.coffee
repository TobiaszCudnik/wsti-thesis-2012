TGraphEntry = ? {
	address: TNodeAddr
	# array of id's from the graphmap
	connections: [...Num]
	# TODO invariant for checking if .connections doenst point to
	#   non-existing index
}

TGraphMap = [...TGraphEntry]

TPlannerNodeClass = ? {
	graph: TGraphMap
	# TODO signal
	getConnections: (TNodeAddr) -> [...TNodeAddr]
	# TODO signal
	getRoutes: -> TGraphMap
}

TPlannerNodeConstructor = ? (TGraphMap, Any, Any, Any) ==> TPlannerNodeClass