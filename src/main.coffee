###*
# Entry point for Moyo.
###
module.exports = (element) ->
	svg = require('svgjs')(element)

	require('./lib/penrose')(svg)

	svg
