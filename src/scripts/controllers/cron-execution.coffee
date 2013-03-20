
CronEngine.controller "CronExecutionController", ($scope, api, cronCarousel)->

  console.log "init cron exec"

  # Events
  $scope.$on "cron.exec", (event,  params) ->
    cronCarousel 2
    $scope.refresh params.jobId, params.execId

  # Data
  $scope.exec = {}

  # Methods
  $scope.refresh = (jobId, execId) ->
    console.log "job exec refresh"
    
    $scope.exec = {}
    api.cronjobs.execs.read(jobId, execId)
      .done (execution) ->
        $scope.exec = execution
        $scope.$apply()
