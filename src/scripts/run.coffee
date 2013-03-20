
#custom routes definition
routes =
  default: '/cron-jobs'
  events:
    'cron.edit': '/cron-jobs/edit/:id'
    'cron.add' : '/cron-jobs/add'
    'cron.exec': '/cron-jobs/:jobId/:execId'
    'cron.job' : '/cron-jobs/:id'
    'cron.jobs': '/cron-jobs'
    'subs.edit' : '/subscribers/edit/:email'
    'subs.add'  : '/subscribers/add'
    'subs'     : '/subscribers'


#configure routes
CronEngine.config ($routeProvider) ->
  console.log "Config!"
  #default route
  if routes.default
    $routeProvider.otherwise {redirectTo: routes.default }
  #wire up events -> route paths
  _.each routes.events, (path, event) ->
    $routeProvider.when path, { action : { path, event } }

#run after the above has been setup
CronEngine.run ($rootScope, $timeout) ->

  console.log "Run!"
  #handle route changes, broadcast events if exists
  $rootScope.$on "$routeChangeSuccess", (event, route) ->
    $timeout ->
      action = route.action
      return unless action
      m = action.path.match /^\/([\w-]+)/
      #section change
      $rootScope.$broadcast 'section', m[1] if m
      #event
      $rootScope.$broadcast action.event, route.params

  #Setup validator
  $("form").asyncValidator
    skipNotRequired: true
    hideErrorOnChange: true
    errorContainer: (e) ->
      e.closest ".control-group"

    prompt: (e, text) ->
      e.siblings(".help-inline").html text or ""

  $.asyncValidator.addFieldRules
    url:
      regex: /^https?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|!:,.;]*[\-A-Za-z0-9+&@#\/%=~_|]/
      message: "Invalid URL"

    header:
      regex: /^.+:.+$/
      message: "Invalid Header"

    tag:
      regex: /^\w+\-*\w+$/
      message: "Invalid Tag"
  
  #Watch window resizes
  resize = ->
    section = $("section:first")
    return if !section.length
    height = window.innerHeight - section.position().top - 10
    section.css "height", height

  $(window).resize resize
  setTimeout resize, 1000
  
  #Set loading cursor for all ajax events
  connections = 0
  $(document).ajaxSend (e) ->
    connections++
    $("body").toggleClass("no-loading", false).toggleClass "loading", true
  .ajaxComplete (e) ->
    connections--
    $("body").toggleClass("no-loading", true).toggleClass "loading", false  unless connections

