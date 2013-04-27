

#mini extensions
$.fn.togglers = ->
  container = $(this)
  togglers = container.find("[data-toggle]")
  togglers.each ->
    btn = $(this)
    selector = btn.attr("data-toggle")
    elem = container.find(selector)
    return  if elem.length is 0
    btn.click ->
      visible = elem.is(":visible")
      text = btn.html()
      btn.html text.replace(/hide|show/i, (if visible then "Show" else "Hide"))
      if visible
        elem.slideUp()
      else
        elem.slideDown()

#intercept all form submissions
handleDemoFormSubmit = ->
  $(this).append successElem.hide().stop().slideDown().delay(2000).slideUp()
  false

successElem = $("<div class=\"alert alert-success\"><strong>" +
    "Validation successful ! </strong> If this was a real form, " +
    "it would be submitting right now...</div>")

$window = $(window)
$document = $(document)

$document.ready ->
  setupTracking()
  setupCode()
  setupNav()
  setupLinks()
  setupWindow()
  $(".loading-cover").fadeOut "fast"
  window.prettyPrint()
  $document.on("submit", "form", handleDemoFormSubmit)
