###*
# Generates rhombic and kites and darts Penrose tilings.
# @submodule Penrose
###


# ================================
# Modules
svg = SVG = require 'svgjs'
tinycolor = require 'tinycolor2'


# ================================
# Constants
sqrt = Math.sqrt
random = Math.random
r = (1 + sqrt 5) / 2


# ================================
# Utilities

# Get some hex string
getRandomColor = () -> tinycolor(h: parseInt(360*random()), s: 0.6, l: 0.6).toHexString()

# Va + Vb
sum = (va, vb) -> [va[0] + vb[0], va[1] + vb[1]]

# Va - Vb
diff = (va, vb) -> [va[0] - vb[0], va[1] - vb[1]]

# Vector * a
mult = (v, a) -> [a * v[0], a * v[1]]


###*
# Inflation logics for "thin" tile type.
# @method inflateThin
# @private
# @param verts {Array} Array of all vertices.
# @param tiles {Array} Array of all tiles.
# @param index {Number} Index of this tile in tiles.
###
inflateThin = (verts, tiles, index) ->
	# Check if @tile received adjacent tile change. If not, propagate old info
	# and let other tiles handle the update
	if @t01.dirty
		c01 = @t01.tile.slice()
		Tadj = c01[0]

		# Adjacent tile already created the new vertex, so use it
		Vnew = tiles[c01[1]].v0
	else
		c01 = @t01.tile
		Tadj = c01

		# Get the new vertex resulting from inflation
		# Vnew = v1 + (r - 1)(v0 - v1)
		Vnew = verts.push(sum(verts[@v1], mult(diff(verts[@v0], verts[@v1]), r - 1))) - 1

	c12 = @t12.tile
	cpair = @pair.tile

	# Reorient @tile
	c0 = @v0
	c1 = @v1
	c2 = @v2

	@v0 = Vnew
	@v1 = c2
	@v2 = c0

	# Create new Tile and push to tiles
	Tnew = tiles.push(new Tile c2, Vnew, c1, "fat", index, Tadj, c12) - 1

	# Propagate to adjacent tiles about my changes, then clean off my dirty flags
	@t01.tile = Tnew
	if c01?
		if @t01.dirty
			tiles[c01[0]].t12.tile = Tnew
			tiles[c01[1]].pair.tile = index
			@pair.tile = c01[1]
		else
			tiles[c01].t01 = {tile: [Tnew, index], dirty: true}
	else @pair.tile = null
	
	if c12?
		if @t12.dirty then tiles[c12].pair.tile = Tnew
		else tiles[c12].t12 = {tile: Tnew, dirty: true}

	if cpair?
		if @pair.dirty then tiles[cpair].t12.tile = index
		else tiles[cpair].pair = {tile: index, dirty: true}
	else @t12.tile = null

	# Finally, reset my dirty flags
	@t01.dirty = false
	@t12.dirty = false
	@pair.dirty = false


###*
# Inflation logics for "fat" tile type.
# @method inflateFat
# @private
# @param verts {Array} Array of all vertices.
# @param tiles {Array} Array of all tiles.
# @param index {Number} Index of this tile in tiles.
###
inflateFat = (verts, tiles, index) ->
	# Check if @tile received adjacent tile changes. If not, propagate old info
	# and let other tiles handle the update
	if @t01.dirty
		c01 = @t01.tile.slice()
		Tthin = c01[1]

		# Adjacent tile already created the new vertex, so use it
		V01 = tiles[c01[1]].v0
	else
		c01 = @t01.tile
		Tthin = c01

		# Get the new vertex resulting from inflation
		# Vnew = v0 + (r - 1)(v1 - v0)
		V01 = verts.push(sum(verts[@v0], mult(diff(verts[@v1], verts[@v0]), r - 1))) - 1

	c12 = @t12.tile
	
	if @pair.dirty
		cpair = @pair.tile.slice()
		Tfat = cpair[1]

		# Adjacent tile already created the new vertex, so use it
		Vpair = tiles[cpair[0]].v0
	else
		cpair = @pair.tile
		Tfat = cpair

		# Get the new vertex resulting from inflation
		# Vnew = v0 + (r - 1)(v2 - v0)
		Vpair = verts.push(sum(verts[@v0], mult(diff(verts[@v2], verts[@v0]), r - 1))) - 1

	# Reorient @tile
	c0 = @v0
	c1 = @v1
	c2 = @v2

	@v0 = Vpair
	@v1 = V01
	@v2 = c0

	# Create new Tiles and push to tiles
	Tnewthin = tiles.push(new Tile V01, Vpair, c1, "thin", index, null, Tthin) - 1
	Tnewfat  = tiles.push(new Tile c2, Vpair, c1, "fat", Tfat, Tnewthin, c12) - 1
	tiles[Tnewthin].t12.tile = Tnewfat

	# Propagate to adjacent tiles about my changes, update my knowledge of adjacent tiles,
	# then clean off my dirty flags
	@t01.tile = Tnewthin
	if c01?
		if @t01.dirty
			@t12.tile = c01[0]
			tiles[c01[0]].t12.tile = index
			tiles[Tthin].pair.tile = Tnewthin
		else
			tiles[c01].t01 = {tile: [index, Tnewthin], dirty: true}
	else @t12.tile = null
	
	if c12?
		if @t12.dirty then tiles[c12].pair.tile = Tnewfat
		else tiles[c12].t12 = {tile: Tnewfat, dirty: true}

	if cpair?
		if @pair.dirty
			@pair.tile = cpair[0]
			tiles[cpair[0]].pair.tile = index
			tiles[Tfat].t01.tile = Tnewfat
		else
			tiles[cpair].pair = {tile: [index, Tnewfat], dirty: true}
	else @pair.tile = null

	# Finally, reset my dirty flags
	@t01.dirty = false
	@t12.dirty = false
	@pair.dirty = false


inflateKite = () ->
inflateDart = () ->

###*
# Contains three vertices and other meta data for a single tile.
# @class Tile
# @constructor
# @private
# @param v0 {Number} vertex 0
# @param v1 {Number} vertex 1
# @param v2 {Number} vertex 2
# @param type {String} Tile type (e.g. kite, dart, thin, fat rhomb...)
# @param tile01 {Number} Array index of a tile adjacent to [v0, v1]. null is rim.
# @param tile12 {Number} Array index of a tile adjacent to [v1, v2]. null is rim.
# @param pair {Number} Array index of tiles which is the other half of this tile (adj to [v2, v3]. null is rim.
###
class Tile
	constructor: (v0, v1, v2, type, tile01, tile12, pair) ->
		@v0 = v0
		@v1 = v1
		@v2 = v2
		@type = @types[type]

		# Adjacency info, where dirty is flag for tile change. This flag
		# is referenced and modified by adjacent tiles when they inflate
		@t01 = tile: tile01, dirty: false
		@t12 = tile: tile12, dirty: false
		@pair = tile: pair, dirty: false

		# Inflation logics for this Tile
		switch type
			when "thin" then @inflate = inflateThin
			when "fat"  then @inflate = inflateFat
			when "kite" then @inflate = inflateKite
			when "dart" then @inflate = inflateDart

	# Enumerate string tile names to save memory
	types:
		thin: 0,
		fat:  1,
		kite: 2,
		dart: 3,
		0: 'thin',
		1: 'fat',
		2: 'kite',
		3: 'dart'


###*
# Implementation for Rhombus Penrose Tiling.
# @class PenroseRhombus
# @constructor
# @private
# @param [opts] {Object} Options to style the tile.
# @param [opts.initTileType="fat"] {String} The starting tile for subsequent inflations. Can be "thin" or "fat".
# @param [...attrs] {Array} Attributes for each tile type.
###
class PenroseRhombus 
	constructor: (opts, attrs...) ->
		# Scope
		@opts = opts

		# Assign defaults
		@opts.initTileType ?= "fat"

		attr = stroke: "#333", "stroke-width": 2, "stroke-linejoin": "round"
		@attrs = []
		@attrs[0] = Object.assign {fill: getRandomColor()}, attr, attrs?[0]
		@attrs[1] = Object.assign {fill: getRandomColor()}, attr, attrs?[1]

		# Initialize
		@verts = []
		@tiles = []


	###*
	# Create first tile, a matching pair of half rhombs.
	# @method createFirstTile
	###
	createFirstTile: (size) ->
		switch @opts.initTileType
			when "thin"
				@verts = [[0, 0], [1, 0], [1+r/2, sqrt((3-r)/4)], [r/2, sqrt((3-r)/4)]]
				@verts[i] = mult @verts[i], 2*(size-1)/r for i in [0..3]
				@tiles = [
					(new Tile 1, 0, 3, "thin", null, null, 1),
					(new Tile 1, 2, 3, "thin", null, null, 0)
				]
			when "fat"
				@verts = [[0, 0], [1, 0], [(1+r)/2, sqrt((r+2)/4)], [(r-1)/2, sqrt((r+2)/4)]]
				@verts[i] = mult @verts[i], 2*size/(1+r) for i in [0..3]
				@tiles = [
					(new Tile 0, 1, 2, "fat", null, null, 1),
					(new Tile 0, 3, 2, "fat", null, null, 0)
				]


	###*
	# Inflate (aka subdivide, decompose) tiles.
	# @method inflate
	# @param times {Number} Number of times to inflate.
	###
	inflate: (times) ->
		for [1..times] by 1
			tile.inflate @verts, @tiles, i for tile, i in @tiles


	###*
	# Take a tile, match with its pair, and nullify the pair. Note that once
	# you call it, this.tiles will no longer be a complete set (will have
	# null entries in the array). Call it just before you draw polys.
	# @method reduce
	# @param tile {Tile} One of the tiles in this.tiles.
	# @return {String} Space-delimited string of vertices.
	###
	reduce: (tile) ->
		# Get matching pair
		pair = @tiles[tile.pair.tile]

		# Calculate polygon vertices
		str = @verts[tile.v0] + ' ' + @verts[tile.v1] + ' '
		if pair? then str += @verts[pair.v2] + ' ' + @verts[pair.v1]
		else
			if @opts.rim == "clip" then str += @verts[tile.v2]
			else if @opts.rim == "subtractive" then str = null 
			else if @opts.rim == "additive"
				# Vmid = v0 + (v2 - v0)/2
				# Vnew = v1 + 2(Vmid - v1)
				str += @verts[tile.v2] + ' ' + sum(@verts[tile.v1], mult(diff(sum(@verts[tile.v0], mult(diff(@verts[tile.v2], @verts[tile.v0]), 1/2)), @verts[tile.v1]), 2))

		# Destroy the pair
		@tiles[tile.pair] = null

		# Return space-delimited string of vertices
		str


	###*
	# Draw a Penrose tiling.
	# @method drawTiles
	# @private
	# @param draw {SVG.Container} SVG.Container instance.
	###
	drawTiles: (draw) ->
		# Create set of sets
		set = draw.set()
		set.add draw.set() for [0..1]

		# Draw tiles as polygons
		for tile in @tiles
			set.get(tile.type).add draw.polygon(@reduce(tile)).attr(@attrs[tile.type])

		# Return set
		set


class PenroseKiteAndDart


# ================================
# Private Methods




# ================================
# Exports

###*
# Creates Penrose tiling.
# @method Moyo.penrose
# @param [width=1000] {Number} Size of initial tile in x axis.
# @param [opts] {Object} Options specific to Penrose tiling.
# @param [opts.type="rhombus"] {String} Which type of Penrose tiling to generate. Available options are "rhombus", "kite and dart", and "original"
# @param [opts.inflation=7] {Number} Number of times to inflate (aka. subdivide, decompose).
# @param [opts.initTileType] {String} The starting tile to which subsequent inflations are applied.
# @param [opts.rim="clip"] {String} What to do with tiling rim after the final inflation. Available options are: clip (clips off tiles), additive (protrudes rim), subtractive (removes clipping tiles)
# @param [...attrs] {Array} Attributes for each tile types (2 types for rhombus and knd, 3 for original).
# @return {SVG.Set} Set of sets containing tiles of the same type.
###
module.exports = (svg) ->
	SVG = svg
	svg.extend SVG.Container,
		penrose: (width, opts, attrs...) ->
			# Overwrite default options
			options = Object.assign {type:"rhombus", inflation:new SVG.Number(7), rim: "clip"}, opts
			options.size = new SVG.Number width ? 100
			options.inflation = new SVG.Number options.inflation

			# Sanity check
			if options.size.unit != '' then throw new Error "width must be a unitless number."
			if not ["rhombus", "rhombs", "kite and dart", "kites and darts", "knd", "original"].includes options.type then throw new Error '"'+options.type+'"'+"is an invalid type."
			if options.inflation.unit != '' then throw new Error "inflation must be a unitless number."

			# Instantiate
			switch options.type
				when "rhombus" then pr = new PenroseRhombus(options)

			# Generate tiles
			pr.createFirstTile options.size.valueOf()
			pr.inflate options.inflation.valueOf()

			# Alas, draw it
			pr.drawTiles @
