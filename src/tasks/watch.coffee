module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-watch'
  
  #watcher config
  watch:
    #update scripts
    coffee:
      files: 'src/scripts/**/*.coffee',
      tasks: 'coffee:dev'
    #update styles
    stylus:
      files: 'src/styles/**/*.styl',
      tasks: 'stylus:dev'
    #update htmls
    jade:
      files: 'src/views/**/*.jade',
      tasks: 'jade:dev'
    #update templates
    templates:
      files: 'src/views/templates/*.*',
      tasks: 'dev'
    #update templates
    grunt:
      files: 'Gruntfile.coffee',
      tasks: 'default'



    #change the manifest
    # includes:
    #   options:
    #     event: ['added', 'deleted']
    #   files: [
    #     'src/scripts/**/*.coffee'
    #     'src/styles/**/*.coffee'
    #     'src/views/**/*.jade'
    #   ]
    #   tasks: 'dev'