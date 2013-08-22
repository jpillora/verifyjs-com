

track = (cat, act, lab, val) ->
  event = ['_trackEvent', cat, act, lab, val]
  unless local()
    _gaq.push event

setupTracking = ->

  $document.on 'click', 'input[type=submit]', ->
    anchor = $(@).closest "[data-nav-anchor]"
    if anchor[0]
      track 'Demo Submit', anchor.attr 'data-nav-anchor' 

  timers = {}
  t = -> new Date().getTime()
  window.trackTiming = (title, active) ->

    if timers[title] and not active
      ms = t() - timers[title]
      track 'Anchor View Length', title, '', ms if ms > 3000
      timers[title] = null

    if not timers[title] and active
      timers[title] = t()


