
CronEngine.controller "SubscribersController", ($scope, $route, api, $location)->

  console.log "init subs"

  #events
  $scope.$on "subs", ->
    $scope.refresh()

  #variables
  $scope.$parent.subs = []

  #methods
  $scope.refresh = ->
    console.log "subs refresh"
    api.observers.read()
      .always (subscribers, result, ajax) ->
        $scope.$parent.subs = subscribers if result is 'success'
        $scope.$apply()

  $scope.add = () ->
    console.log "add!"
    window.location.hash = "/subscribers/add"

  $scope.edit = (sub) ->
    console.log "edit!"
    window.location.hash = "/subscribers/edit/#{sub.email}"

  $scope.remove = (sub) ->
    console.log "remove!"
    return unless confirm("Are you sure you want to delete this subscriber ?")

    api.observers
      .del(sub.email)
      .always (data, result) ->
        api.cache.clear()
        $scope.$root.$broadcast 'subs'
