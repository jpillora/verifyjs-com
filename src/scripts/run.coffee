
#helpers
encode = (value) ->
  $("<div/>").text(value).html()
prettify = (str) ->
  prettyPrintOne encode(str)
create = (type) ->
  $ document.createElement(type)
slugify = (title) ->
  title.replace(/\s/g, "-").toLowerCase()

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
  $(this).append successElem.show().stop().delay(2000).fadeOut()
  false

successElem = $("<div class=\"alert alert-success\"><strong>" +
    "Validation successful ! </strong> If this was a real form, it would be submitting right now..." +
     "</div>")

$window = $(window)
$document = $(document)

$document.ready ->
  setupCode()
  setupNav()
  setupLinks()
  setupWindow()
  $(".loading-cover").fadeOut "fast"
  window.prettyPrint()
  $document.on("submit", "form", handleDemoFormSubmit)
