setupLinks = ->

  get = (id) -> $("[data-anchor=#{id}]")

  #setup data links
  $("a[data-link]").each ->
    curr = $(@).attr 'data-link'
    if curr and curr isnt 'data-link'
      id = curr
    else
      id = slugify $.trim $(@).text()
    $(@).attr 'href', '#'+id
    console.warn "missing: ", id if get(id).length is 0

  #auto set anchors
  $("[data-anchor]").each ->
    curr = $(@).attr 'data-anchor'
    return if curr and curr isnt 'data-anchor'
    id = slugify $.trim $(@).text()
    $(@).attr 'data-anchor', id
  
  $window.on 'hashchange', ->
    hash = location.hash.substr(1)
    return unless hash
    
    track 'Go To',  hash
    elem = get hash

    if elem.length is 0
      alert "Sorry those docs are still in progress !"
    else
      $('html,body').animate(
        {scrollTop: elem.offset().top},
        {duration: 1000, easing: 'easeInOutExpo'}
      );

  $window.trigger 'hashchange'

