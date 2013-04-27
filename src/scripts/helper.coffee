#helpers
encode = (value) ->
  $("<div/>").text(value).html()
prettify = (str) ->
  prettyPrintOne encode(str)
create = (type) ->
  $ document.createElement(type)
slugify = (title) ->
  title.replace(/\s/g, "-").toLowerCase()

local = ->
  /localhost/.test window.location.host