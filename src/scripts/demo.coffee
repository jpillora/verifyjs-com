define ["util/log", "underscore", 
        "lib/prettify", "lib/bootstrap.min"],
        (log) ->
  setCode = (container, pre) ->
    return  if container.length is 0 or pre.length is 0
    content = container.html()
    lines = content.split("\n")
    indentation = undefined
    content = ""
    i = 0
    l = lines.length

    while i < l
      line = lines[i]
      continue  if i is 0 or i is l - 1
      if indentation is `undefined`
        m = line.match(/^(\ *)/)
        indentation = m[1]  if m
      line = line.replace(new RegExp("^" + indentation), "")
      content += line + "\n"
      ++i
    pre.append prettify(content)
  
  #helpers
  encode = (value) ->
    $("<div/>").text(value).html()
  prettify = (str) ->
    prettyPrintOne encode(str)
  create = (type) ->
    $ "<" + type + "/>"
  slugify = (title) ->
    title.replace(/\s/g, "-").toLowerCase()
  setupNav = ->
    setupNavHeading = ->
      heading = $(this).data("nav-heading")
      slug = slugify(heading)
      first = $(this).children(":first")
      $(this).prepend $("<h3/>").html(heading)  unless first.is("h3")
      $(this).attr "id", slug
      navList.append header(heading: heading)
      $(this).find("[data-nav-anchor]").each setupNavAnchor
    setupNavAnchor = ->
      title = $(this).data("nav-anchor")
      slug = slugify(title)
      first = $(this).children(":first")
      $(this).prepend $("<h4/>").html(title)  unless first.is("h4")
      $(this).attr "id", slug
      navList.append anchor(
        title: title
        slug: slug
      )
    header = _.template("<li class=\"nav-header\"><%= heading %></li>")
    anchor = _.template("<li><a href=\"#<%= slug %>\"><%= title %></a></li>")
    navList = $("#nav-list")
    $("[data-nav-heading]").each setupNavHeading
  setupLinks = ->
    $("a[data-link]").each ->
      sel = "#" + slugify($(this).html())
      $(this).attr "href", sel
      console.log "missing: ", this  if $(sel).length is 0

  setupCodeSnippets = ->
    $(".demo").each ->
      demo = $(this)
      htmlDemo = demo.find("div[data-html]")
      htmlPre = demo.find("pre[data-html]")
      scriptDemo = demo.find("script[data-script]")
      scriptPre = demo.find("pre[data-script]")
      setCode htmlDemo, htmlPre
      setCode scriptDemo, scriptPre

  setupHighlightTable = ->
    $(".highlight-col3-table tbody tr").each ->
      codeCol = $(this).children().eq(2)
      codeCol.html prettify(codeCol.html())

  
  # dom listeners
  handleHashClick = (e) ->
    e.preventDefault()
    id = $(this).attr("href")
    elem = $(id).scrollView(->
      window.location.hash = id
    )
    alert "Sorry those docs are still in progress !"  if elem.length is 0
    false
  
  #intercept all form submissions
  handleDemoFormSubmit = ->
    $(this).append successElem.show().stop().delay(2000).fadeOut()
    false
  window.$ = $
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



  successElem = $("<div class=\"alert alert-success\"><strong>" + "Validation successful ! </strong> If this was a real form, it would be submitting right now..." + "</div>")
  $(document).ready ->
    setupNav()
    setupLinks()
    setupCodeSnippets()
    setupHighlightTable()
    $(".loading-cover").fadeOut "fast"
    window.prettyPrint()
    $(document).on("submit", "form", handleDemoFormSubmit).on "click", "a[href^=#]", handleHashClick

