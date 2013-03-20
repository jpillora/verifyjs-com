
CronEngine.controller "CronJobController", ($scope, api, cronCarousel)->

  console.log "init cronjob"

  # Events
  $scope.$on "cron.job", (event, params) ->
    cronCarousel 1
    $scope.refresh params.id

  # Data
  $scope.job = {}
  $scope.executions = []

  #methods
  $scope.trigger = ->
    id = $scope.job.cronJobId
    return unless id
    api.cronjobs.trigger(id).done ->
      $(".trigger").html "Running..."
      setTimeout ->
        $(".trigger").html "Trigger"
      , 2000

  $scope.select = (exec) ->
    window.location.hash = "/cron-jobs/#{$scope.job.cronJobId}/#{exec.cronExecutionId}"

  $scope.refresh = (id) ->
    console.log "job refresh", id
    
    $scope.job = {}
    api.cronjobs.read(id)
      .done (job) ->
        $scope.job = job
        $scope.$apply()

    $scope.executions = []
    api.cronjobs.execs.read(id)
      .done (executions) ->
        $scope.executions = executions
        $scope.$apply()