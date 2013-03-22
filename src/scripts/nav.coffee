setupNav = ->

  setupNavHeading = ->
    heading = $(this).data("nav-heading")
    slug = slugify(heading)
    first = $(this).children(":first")
    $(this).prepend create("h3").html(heading)  unless first.is("h3")
    $(this).attr "id", slug
    container = create("div")
    container.append headerTemplate(heading: heading)
    $(this).find("[data-nav-anchor]").each ->
      setupNavAnchor container, $(this)

    navList.append container

  setupNavAnchor = (container, anchor) ->
    title = anchor.data("nav-anchor")
    slug = slugify(title)
    first = anchor.children(":first")
    anchor.prepend create("h4").html(title)  unless first.is("h4")
    anchor.attr "id", slug
    container.append anchorTemplate(
      title: title
      slug: slug
    )

  headerTemplate = _.template("<li class=\"nav-header\"><%= heading %></li>")
  anchorTemplate = _.template("<li><a href=\"#<%= slug %>\"><%= title %></a></li>")

  navList = $("#nav-list")

  $("[data-nav-heading]").each setupNavHeading
