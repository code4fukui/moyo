###*
# Entry point for Moyo browserify.
###
if window? then window.Moyo = moyo = require 'svgjs'

require('./lib/penrose.coffee') moyo
