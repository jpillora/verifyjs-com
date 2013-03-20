CronEngine.factory "cronCarousel", ->
  console.log "init carousel"

  # Cached selectors
  cronCarousel = $("#cronCarousel")
  cronCarousel.carousel interval: false

  #go to slide
  (n) -> cronCarousel.carousel n