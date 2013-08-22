
sections = []
anchors = []

setupNav = ->

  setupNavHeading = ->

    section = $(@)
    heading = section.data("nav")
    slug = slugify(heading)
    first = section.children(":first")
    section.prepend create("h3").html(heading)  unless first.is("h3")
    section.attr "data-anchor", slug

    li = headerTemplate(heading: heading)

    container = create("div").addClass("nav-section")
    container.append li

    $(this).find(".demo[data-nav]").each ->
      setupNavAnchor container, $(this)

    navList.append container

    sections.push { type:'section', content: section, nav: container }

  setupNavAnchor = (container, anchor) ->
    title = anchor.data("nav")
    slug = slugify(title)
    first = anchor.children(":first")
    #auto add title (if needed)
    anchor.prepend create("h4").html(title) unless first.is("h4")
    anchor.attr "data-anchor", slug
    li = $(anchorTemplate(
      title: title
      slug: slug
    ))
    container.append li
    anchors.push { type:'anchor', content: anchor, nav: li, title }

  headerTemplate = _.template("<li class='nav-header'><%= heading %></li>")
  anchorTemplate = _.template("<li class='nav-item'><a href='#<%= slug %>''><%= title %></a></li>")

  navList = $("#nav-list")

  $(".row-fluid[data-nav]").each setupNavHeading

  check = ->
    _.each sections, activeInView
    _.each anchors, activeInView

  activeInView = (obj) ->
    isActive = obj.content.is ':in-viewport'
    obj.nav.toggleClass 'active', isActive

    # TODO - use ticker method
    # if obj.type is 'anchor'
    #   trackTiming obj.title, isActive


  $document.scroll _.throttle check
  $document.trigger 'scroll'
