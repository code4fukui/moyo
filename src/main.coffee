###*
# Entry point for Moyo.
###
require './lib/penrose.coffee'

if window? then window.Moyo = require 'svgjs'
module.exports = require 'svgjs'
