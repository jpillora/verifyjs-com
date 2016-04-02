sections = []
anchors = []
setupNav = ->
  setupNavHeading = ->
    section = $(@)
    heading = section.data("nav-heading")
    slug = slugify(heading)
    first = section.children(":first")
    section.prepend create("h3").html(heading)  unless first.is("h3")
    section.attr "nav-id", slug
    li = headerTemplate(heading: heading)
    container = create("div").addClass("nav-section")
    container.append li
    $(this).find("[data-nav-anchor]").each ->
      setupNavAnchor container, $(this)
    navList.append container
    sections.push { type:'section', content: section, nav: container }
  setupNavAnchor = (container, anchor) ->
    title = anchor.data("nav-anchor")
    slug = slugify(title)
    first = anchor.children(":first")
    #auto add title (if needed)
    anchor.prepend create("h4").html(title) unless first.is("h4")
    anchor.attr "nav-id", slug
    li = $(anchorTemplate(
      title: title
      slug: slug
    ))
    container.append li
    anchors.push { type:'anchor', content: anchor, nav: li, title }
  headerTemplate = _.template("<li class='nav-header'><%= heading %></li>")
  anchorTemplate = _.template("<li class='nav-item'><a href='#<%= slug %>''><%= title %></a></li>")
  navList = $("#nav-list")
  $("[data-nav-heading]").each setupNavHeading
  check = ->
    _.each sections, activeInView
    _.each anchors, activeInView
  activeInView = (obj) ->
    isActive = obj.content.is ':in-viewport'
    obj.nav.toggleClass 'active', isActive
    if obj.type is 'anchor'
      trackTiming obj.title, isActive
  $document.scroll _.throttle check
  $document.trigger 'scroll'
