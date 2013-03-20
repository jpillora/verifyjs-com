module.exports = (grunt) ->

  #task
  grunt.loadNpmTasks 'grunt-aws'

  #config
  aws:
    options:
      config:
        accessKeyId: 'AKIAIZH33HZWMEKUSMQA'
        secretAccessKey: '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'
        region: 'ap-southeast-1'
      services:
        s3:
          bucket: 'think-console'
          access: 'public-read'
        route53:
          test: 42

    deployDev:
      service: 's3'
      options:
        foo: 42
      files:
        src: './build/dev/**/*.*'
        dest: '.'


    # deployTest:
    #   service: 'route53'
    #   options:
    #     key: 'foo'
    #   files: './src/**/*.coffee'
