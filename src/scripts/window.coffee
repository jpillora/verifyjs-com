setupWindow = ->

  sidebar = $('.sidebar-nav')
  # content = $('.content-wrapper')

  resizeViewport = ->
    console.log "resize"
    sidebar.height $window.height()

  #hide show navs based on viewport
  $window.resize _.debounce resizeViewport
  resizeViewport()
