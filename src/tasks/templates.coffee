glob = require "glob-manifest"
async = require "async"
_ = require "lodash"
jade = require "jade"

class TemplatesRun

  #types of buildable files
  wrapper:  _.template """
      <script id="<%= id %>-template" type="text/template">
      <%= content %>
      </script>
    """

  constructor: (@grunt, @name, @data, @done) ->
    #opts
    _.bindAll @
    @opts = @data.options or {}

    builds = _.map @data.build, (globs, dest) ->
      { dest, globs }

    async.each builds, @build, (err) =>
      if err isnt null
        @grunt.fail.warn err
        return done false
      done true

  #build files
  build: (obj, callback) ->

    glob obj.globs, (error, files) =>
      if error isnt null
        return callback(error)

      templates = files.map @template

      @grunt.file.write obj.dest, templates.join("\n")
      callback()

  #build one file
  template: (filepath) ->

    # console.log "template: #{filepath}"
    m = filepath.match /([^\/]+)\.([^\.]+)$/
    if not m
      return grunt.fail.warn "No file type: #{filepath}"

    name = m[1]
    ext = m[2]

    content = @grunt.file.read(filepath)
    content = jade.compile(content)() if ext is 'jade'

    return @wrapper({ id: name, content: content })

module.exports = (grunt) ->
  # define new task
  grunt.registerMultiTask "templates", "Build Templates", ->
    new TemplatesRun(grunt, @target, @data, @async())

  #and finally, config
  templates:
    dev:
      build:
        './src/views/generated/templates.html': [
          './src/views/templates/*.html',
          './src/views/templates/*.jade'
        ]






