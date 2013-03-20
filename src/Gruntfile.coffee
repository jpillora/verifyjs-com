require "coffee-script"
_ = require "lodash"
fs = require "fs"

# Build configurations.
module.exports = (grunt) ->

  #combine all task configs
  config = {}
  fs.readdirSync("tasks/").forEach (file) ->
    path = "./tasks/#{file}"
    if fs.statSync(path).isFile()
      name = path.replace /\.coffee$/, ''
      try
        grunt.verbose.writeln "Loading task: '#{name}'"
        task = require name
        _.extend config, task(grunt)
      catch e
        grunt.fail.warn "Failed to load task: #{path}\n#{e}"
      
  #initialise
  grunt.initConfig config

  #default: both dev and test
  grunt.registerTask 'default', [
    'dev'
    'test'
  ]

  grunt.registerTask 'dev', [
    'clean:dev'
    'stylus:dev'
    'coffee:dev'
    'includes:dev'
    'templates:dev'
    'jade:dev'
    'clean:temp'
  ]

  grunt.registerTask 'test', [
    'clean:test'
    'coffee:test'
    'jade:test'
    'clean:temp'
  ]