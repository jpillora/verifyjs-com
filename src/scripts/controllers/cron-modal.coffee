
CronEngine.controller "CronModalController", ($scope, $route, api, $element) ->

  console.log "init modal controller"

  editModal = $("#cronModal")

  editModal.on "hidden", ->
    $scope.back()

  newJob =
    cronJobId: null
    url: "http://www.google.com"
    timeout: 60
    frequency: "every 5 hours"
    tagList: ["my-tag"]
    headerList: []

  updateJob = (data) ->
    _.extend $scope, data
    $scope.$apply()

  $scope.isNew = -> !$scope.cronJobId

  $scope.type = -> if $scope.isNew() then "New" else "Edit"

  #catch events

  $scope.$on 'cron.add', () ->
    console.log 'add'
    updateJob newJob
    editModal.modal "show"

  $scope.$on 'cron.edit', (event, params) ->
    console.log 'edit'
    api.cronjobs.read(params.id).done (job) ->
      updateJob job
      editModal.modal "show"

  # save / create
  $scope.commitJob = ->
    console.log 'commit!'

    data = _.pick $scope, 'url', 'frequency', 'tagList', 'headerList', 'timeout'
    console.log data

    #validate all inputs
    $element.find('form').validate (r) ->
      return unless r

      #create or edit...
      req = if $scope.isNew()
        api.cronjobs.create(data)
      else 
        api.cronjobs.update($scope.cronJobId, data)

      #on success
      req.done ->
        editModal.modal 'hide'
        $scope.$root.$broadcast 'cron.jobs.change'




