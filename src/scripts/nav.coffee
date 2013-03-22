setupNav = ->

  sections = []

  setupNavHeading = ->

    section = $(@)
    heading = section.data("nav-heading")
    slug = slugify(heading)
    first = section.children(":first")
    section.prepend create("h3").html(heading)  unless first.is("h3")
    section.attr "id", slug

    li = headerTemplate(heading: heading)
    navList.append li

    container = create("div").addClass("nav-anchors")
    $(this).find("[data-nav-anchor]").each ->
      setupNavAnchor container, $(this)
    navList.append container

    sections.push { elem: section, container, shown: false }

  setupNavAnchor = (container, anchor) ->
    title = anchor.data("nav-anchor")
    slug = slugify(title)
    first = anchor.children(":first")
    #auto add title (if needed)
    anchor.prepend create("h4").html(title) unless first.is("h4")
    anchor.attr "id", slug
    li = $(anchorTemplate(
      title: title
      slug: slug
    ))
    container.append li

  headerTemplate = _.template("<li class=\"nav-header\"><%= heading %></li>")
  anchorTemplate = _.template("<li><a href=\"#<%= slug %>\"><%= title %></a></li>")

  navList = $("#nav-list")

  $("[data-nav-heading]").each setupNavHeading

  checkViewport = ->
    _.each sections, (section) ->
      onScreen = section.elem.is(":in-viewport")
      if onScreen and not section.shown
        section.container.slideDown()
        section.shown = true
        console.log("show", section.elem)
      else if not onScreen and section.shown
        section.container.slideUp()
        section.shown = false
        console.log("false", section.elem)

  #hide show navs based on viewport
  $(document).scroll _.throttle checkViewport
