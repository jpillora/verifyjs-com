setupLinks = ->

  get = (id) -> $("[nav-id=#{id}]")

  #setup data links
  $("a[data-link]").each ->
    id = slugify $.trim $(@).text()
    $(@).attr 'href', '#'+id
    console.warn "missing: ", id if get(id).length is 0
  
  $window.on 'hashchange', ->
    hash = location.hash.substr(1)
    return unless hash
    
    elem = get hash

    track 'Go To', elem.text() or hash

    if elem.length is 0
      alert "Sorry those docs are still in progress !"
    else
      $('html,body').animate(
        {scrollTop: elem.offset().top},
        {duration: 1000, easing: 'easeInOutExpo'}
      );

  $window.trigger 'hashchange'

