setupLinks = ->
  
  handleHashClick = (e) ->
    e.preventDefault()
    id = $(this).attr("href")
    elem = $(id).scrollView(->
      window.location.hash = id
    )
    alert "Sorry those docs are still in progress !"  if elem.length is 0
    false

  $(document).on "click", "a[href^=#]", handleHashClick

  $("a[data-link]").each ->
    sel = "#" + slugify($(this).html())
    $(this).attr "href", sel
    console.log "missing: ", sel if $(sel).length is 0
