module.exports = (grunt) ->

  #task
  grunt.loadNpmTasks 'grunt-contrib-stylus'

  #config
  stylus:
    dev:
      files:
        'build/dev/styles/app.css': 'src/styles/app.styl'

#   options:
#     paths: ["path/to/import", "another/to/import"]

#     use embedurl('test.png') in our code to trigger Data URI embedding
#     urlfunc: "embedurl"

#     use stylus plugin at compile time
#     use: [require("fluidity")]
#      @import 'foo', 'bar/moo', etc. into every .styl file
#      that is compiled. These might be findable based on values you gave

#      to `paths`, or a plugin you added under `use`
#     import: ["foo", "bar/moo"] 
        
