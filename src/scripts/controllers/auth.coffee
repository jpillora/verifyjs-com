CronEngine.controller "AuthController", ($scope, api, $timeout)->

  console.log "init auth"

  $root = $scope.$root

  $scope.username = ""
  $scope.password = ""

  if(window.localStorage)
    $scope.username = window.localStorage.username
    $scope.password = window.localStorage.password

  $root.hasUser = false

  $scope.toggleAuth = ->
    console.log "toggle"
    if $scope.hasUser then $scope.logout() else $scope.login()

  $scope.login = ->
    console.log "login"
    u = $scope.username
    p = $scope.password
    return if not u or not p
    api.opts.username = u
    api.opts.password = p

    if(window.localStorage)
      window.localStorage.username = u
      window.localStorage.password = p

    $root.hasUser = true
    $root.$broadcast 'auth.login'

  $scope.logout = ->
    console.log "logout"
    $scope.username = ""
    $scope.password = ""
    $root.hasUser = false
    $root.$broadcast 'auth.logout'

  $scope.$on 'app.ready', ->
    $scope.login()
