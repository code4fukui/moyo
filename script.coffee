###*
# Script for dev tasks.
###

{TaskGroup} = require 'taskgroup'


###*
# Display project version.
###
version = new TaskGroup storeResult: true, concurrency: 0

# Load package.json version
version.addTask () ->
	pack = require './package.json'
	return pack.version

# Load yuidoc.json version
version.addTask () ->
	yuidoc = require './yuidoc.json'
	return yuidoc.version

version.done (err, results) ->
	if err? then console.log err

	if results[0][1] != results[1][1]
		console.log 'Versions in package.json (' + results[0][1] + ') and yuidoc.json (' + results[1][1] + ') don\'t match.'
	else
		console.log 'Project version: ' + results[0][1]


###*
# Process arguments and run tasks.
###
for argv in process.argv
	switch argv
		when 'version', '-v'
			version.run()
