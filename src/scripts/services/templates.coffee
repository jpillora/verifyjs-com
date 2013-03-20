CronEngine.factory "templates", ->
  console.log "init templates"
  cache = {}
  (name) ->
    return cache[name] if cache[name]
    template = $("##{name}-template")
    throw "cant find template: #{name}" if template.length is 0
    str = template.html()

    if str.match /<%=?\s*\w+\s*%>/
      try
        compiled = _.template str
      catch e
        throw "Underscore.js Error: #{e}"
      cache[name] = compiled
    else
      cache[name] = str

    cache[name]