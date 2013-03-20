CronEngine.directive "hasClass", ->
  (scope, element, attrs) ->
    console.log "compile 'hasClass'"
    scope.$watch attrs.hasClass