CronEngine.filter 'date', ->
  (input) ->
    ms = parseInt input, 10
    return '' if isNaN ms
    moment(ms).format("YYYY-MM-DD HH:mm:ss")