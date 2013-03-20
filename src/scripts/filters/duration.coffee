CronEngine.filter 'duration', ->
  (input) ->
    ms = parseInt input, 10
    return '' if isNaN ms
    result = ''
    if ms < 1000
      result = ms + " ms"
    else
      result = moment.duration(ms, "ms").humanize()
    result