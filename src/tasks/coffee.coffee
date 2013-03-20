exec = require('child_process').execFile
fs = require('fs')

parseOptions = (opts) ->
  args = []
  for key, val of opts
    continue unless val
    dashes = if key.length is 1 then '-' else '--'
    args.push dashes+key
    args.push val if val isnt true
  args


module.exports = (grunt) ->
  # define new task
  grunt.registerMultiTask "coffee", "OS Compile", ->
    done = @async()
    #subtask (dev, test, prod)
    name = @target

    #src dir checks
    src = @data.src
    unless fs.existsSync(src)
      grunt.log.writeln "'#{name}': '#{src}' does not exist. Skipping."
      return done true

    #dest dir checks
    dest = @data.dest
    unless fs.existsSync(dest)
      grunt.file.mkdir dest
    stats = fs.statSync dest
    if stats.isFile()
      grunt.log.writeln "'#{name}': '#{dest}' must be directory."
      return done true

    grunt.log.writeln "'#{name}': '#{src}' into '#{dest}"

    args = parseOptions @data.options
    args.push '--compile'
    args.push '--output'
    args.push dest
    args.push src

    grunt.verbose.writeflags(args, 'Options');
    
    bin = './node_modules/coffee-script/bin/coffee'
    exec bin, args, {}, (error, stdout, stderr) ->
      if error isnt null
        grunt.log.writeln error
        return done false
      grunt.log.writeln stdout if stdout
      grunt.log.writeln stderr if stderr
      done true

  #and the config
  coffee:
    dev:
      src: 'src/scripts/'
      dest: './build/dev/scripts/'
      options:
        b: true
    test:
      src: 'test/scripts/'
      dest: 'build/test/scripts/'
