module.exports = (grunt) ->

  #customize lib
  # require('./node_modules/grunt-contrib-jade/node_modules/jade').filters.foo = (str) ->
  #   str.replace /\s+/g, 'foo'

  #task
  grunt.loadNpmTasks 'grunt-contrib-jade'

  #config
  jade: 
    dev:
      options:
        pretty: true
      files: 
        'build/dev/index.html': './src/views/index.jade'
    test:
      options:
        pretty: true
        data:
          debug: true
      files: 
        'build/test/test/': './test/test/**/*.jade'