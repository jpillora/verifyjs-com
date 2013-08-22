
sections = []
topics = []
subtopics = []

setupNav = ->

  navList = $("#nav-list")
  navList.empty()

  setupSections = ->
    section = $(@)
    heading = section.data("nav")
    slug = slugify(heading)
    first = section.children(":first")
    section.prepend create("h3").html(heading)  unless first.is("h3")
    section.attr "data-anchor", slug

    li = headerTemplate(heading: heading)

    container = create("div").addClass("nav-section")
    container.append li

    $(this).find(".topic[data-nav]").each ->
      setupTopics container, $(this)

    navList.append container

    sections.push { type:'section', content: section, nav: container }

  setupTopics = (container, topic) ->
    title = topic.data("nav")
    slug = slugify(title)
    first = topic.children(":first")
    #auto add title (if needed)
    topic.prepend create("h4").html(title) unless first.is("h4")
    topic.attr "data-anchor", slug
    li = $(anchorTemplate(
      title: title
      slug: slug
    ))
    container.append li
    topics.push { type:'anchor', content: topic, nav: li, title }

  headerTemplate = _.template("<li class='nav-header'><%= heading %></li>")
  anchorTemplate = _.template("<li class='nav-item'><a href='#<%= slug %>''><%= title %></a></li>")
  
  $(".section[data-nav]").each setupSections

  check = ->
    _.each sections, activeInView
    _.each topics, activeInView

  activeInView = (obj) ->
    isActive = obj.content.is ':in-viewport'
    obj.nav.toggleClass 'active', isActive

    # TODO - use ticker method
    # if obj.type is 'anchor'
    #   trackTiming obj.title, isActive

  $document.scroll _.throttle check
  $document.trigger 'scroll'
