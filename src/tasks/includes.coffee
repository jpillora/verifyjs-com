glob = require "glob-manifest"
async = require "async"
_ = require "lodash"

class IncludesRun

  #types of buildable files
  templates:
    js: _.template '<script src="<%= src %>"></script>' 
    css: _.template '<link rel="stylesheet" href="<%= src %>"/>' 

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

      contents = files.map @template

      @grunt.file.write obj.dest, contents.join("\n")
      callback()

  #build one file
  template: (filepath) ->

    filepath = filepath.replace(@opts.root, '') if @opts.root

    # console.log "template: #{filepath}"
    m = filepath.match /\.([^\.]+)$/
    if not m
      return grunt.fail.warn "No file type: #{filepath}"

    ext = m[1]
    if not @templates[ext]
      return grunt.fail.warn "Unkown file type: #{ext}"
    
    return @templates[ext]({ src: filepath})

module.exports = (grunt) ->
  # define new task
  grunt.registerMultiTask "includes", "Include Scripts via Jade", ->
    new IncludesRun(grunt, @target, @data, @async())

  #and finally, config
  includes:
    dev:
      options:
        root: './build/dev/'
      build:
        #scripts
        './src/views/generated/scripts.html': [
          #jquery and friends
          '//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js'
          'http://jpillora.github.com/jquery.async.validator/dist/jquery.async.validator.js'
          'http://jpillora.github.com/jquery.rest/dist/jquery.rest.js'
          #bootstrap
          '//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js'
          #angular
          '//ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.js'
          #util function
          '//cdnjs.cloudflare.com/ajax/libs/lodash.js/1.0.1/lodash.min.js'
          '//cdnjs.cloudflare.com/ajax/libs/moment.js/2.0.0/moment.min.js'

          './build/dev/scripts/init.js'
          './build/dev/scripts/services/*.js'
          './build/dev/scripts/filters/*.js'
          './build/dev/scripts/directives/*.js'
          './build/dev/scripts/controllers/*.js'
          './build/dev/scripts/run.js'
        ],
        #styles
        './src/views/generated/styles.html': [
          '//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap.min.css'
          './build/dev/**/*.css'
        ]
    






