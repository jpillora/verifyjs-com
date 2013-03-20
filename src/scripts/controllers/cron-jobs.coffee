
CronEngine.controller "CronJobsController", ($scope, $route, api, $location, cronCarousel) ->

  console.log "init cronjobs"

  #events
  $scope.$on "auth.login", ->
    $scope.refresh()

  $scope.$on "cron.jobs", ->
    cronCarousel 0
    $scope.refresh()

  #variables
  $scope.jobs = []

  #methods
  $scope.refresh = ->
    console.log "jobs refresh"
    api.cronjobs.read()
      .always (jobs, result, ajax) ->
        $scope.jobs = jobs if result is 'success'
        $scope.$apply() 

  $scope.select = (job) ->
    window.location.hash = "/cron-jobs/#{job.cronJobId}"

  $scope.edit = (job, $event) ->
    $event.stopPropagation()
    window.location.hash = "/cron-jobs/edit/#{job.cronJobId}"

  $scope.remove = (job, $event) ->
    $event.stopPropagation()

    index = $scope.jobs.indexOf job
    return console.error("missing job") if index is -1

    return unless confirm("Are you sure you want to delete this job ?")
    api.cronjobs
      .del(job.cronJobId)
      .always (data, result) ->
        api.cache.clear()
        $scope.$root.$broadcast 'cron.jobs'
