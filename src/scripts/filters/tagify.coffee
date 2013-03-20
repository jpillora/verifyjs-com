CronEngine.filter 'tagify', (templates) ->
  label = templates('label')
  (input) ->

    arr = input

    unless $.isArray(arr) and arr.length > 0
      return label({ type: 'default', content: 'None' })

    arr = _.map arr, (str) ->
      label({ type: 'info', content: str })

    arr.join ' '
