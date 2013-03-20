CronEngine.directive "arrayInput", (templates) ->
  restrict: 'EAC'
  replace: true
  scope:
    label: "@label"
    placeholder: "@placeholder"
    modelName: "@modelName"
    validate: "@validate"

  template: templates "array-input"

  controller: ($scope, $element, $timeout) ->

    #alias
    arr = ->
      name = $scope.modelName
      throw "array input: 'modalName' missing" unless name
      a = $scope.$parent[name]
      return [] unless a
      a

    #scope not ready, delay
    $timeout ->
      $scope.$parent.$watch $scope.modelName, getList

    #map the canonical list (str->object to allow binding)
    getList = ->
      $scope.list = _.map arr(), (val,index) -> {val, index}

    #on input changes directly modify the canonical list
    $element.on 'keyup', '.existing-item',  ->
      index = $(@).data 'index'
      arr()[index] = $(@).val()

    #add to canonical, remap
    $scope.addItem = ->
      arr().push ''
      getList()

    #remove from canonical, remap
    $scope.removeItem = (item) ->
      arr().remove item.index
      getList()

    null
