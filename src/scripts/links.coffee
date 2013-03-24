setupLinks = ->

  get = (id) -> $("[nav-id=#{id}]")

  $window.on 'hashchange', ->
    console.log "hash change"
    elem = get location.hash.substr(1)
    if elem.length is 0
      alert "Sorry those docs are still in progress !"
    else
      $('html,body').animate(
        {scrollTop: elem.offset().top},
        {duration: 1000, easing: 'easeInOutExpo'}
      );

  $window.trigger 'hashchange'

  $("a[data-link]").each ->
    id = slugify $(@).text()
    $(@).attr 'href', '#'+id
    console.log "missing: ", id if get(id).length is 0
