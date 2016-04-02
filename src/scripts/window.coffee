setupWindow = ->
  sidebar = $('.sidebar-nav')
  # content = $('.content-wrapper')
  padding = 20
  gap = 20
  shares = $('.share-buttons').height()
  resizeViewport = ->
    sidebar.height $window.height() - (padding+gap+shares)
  #hide show navs based on viewport
  $window.resize _.debounce resizeViewport
  resizeViewport()
