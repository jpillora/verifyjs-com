CronEngine.filter 'headerify', (templates) ->
  label = templates('label')
  (input, includeValue = false) ->

    arr = input

    unless $.isArray(arr) and arr.length > 0
      return label({ type: 'default', content: 'None' })

    arr = _.map arr, (str) ->
      parts = str.split /\s*:\s*/
      key = parts[0]
      val = parts[1]

      content = key
      content += ': ' + val if includeValue

      label({ type: 'warning', content })

    arr.join ' '
