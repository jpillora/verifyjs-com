#define root controller
# handles screen changes
CronEngine.controller "EngineController", ($scope, slugify, $timeout) ->
  
  console.log "init engine"

  $scope.back = ->
    history.back() if history

  #notify all that application is ready
  $ -> $scope.$broadcast 'app.ready'

  # change section event
  $scope.$on 'section', (event, section) ->
    $scope.changeSection section

  # Sections
  $scope.sections =
    cron: "Cron Jobs"
    subs: "Subscribers"

  $scope.activeSection = (section) ->
    if slugify(section) is $scope.currentSection then "active" else ""

  $scope.changeSection = (section) ->
    return if section is $scope.currentSection
    console.log "change section: #{section}"
    $scope.currentSection = section
    className = slugify section
    currSection = $(".#{className}")
    otherSections = $("section:not(.#{className})")
    unless currSection.length
      console.warn "Missing section: ", section
      currSection = $("section:first")
    otherSections.fadeOut ->
      currSection.fadeIn()

  #go to cron by default
  $scope.changeSection $scope.sections.cron




