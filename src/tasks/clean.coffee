glob = require "glob-manifest"
async = require "async"

module.exports = (grunt) ->

  # define new task
  grunt.registerMultiTask "clean", "Delete Globs", ->
    done = @async()
    #subtask (dev, test, prod)
    name = @target

    glob @data, (err, files) ->
      if err isnt null
        grunt.fail.warn err
        return done false
      for f in files
        grunt.file.delete f
      done true

  #and finally, config
  clean:
    dev:  'build/dev/'
    test: 'build/test/'
    temp: 'temp/'
    
  