

CronEngine.controller "SubcriberModalController", ($scope, $route, api, $element) ->

  console.log "init subs modal controller"

  editModal = $("#subsModal")

  editModal.on "hidden", ->
    $scope.back()

  #catch events
  $scope.$on 'subs.add', () ->
    console.log 'add'
    updateSub { email: '', tagList: [] }
    editModal.modal "show"

  $scope.$on 'subs.edit', (event, params) ->
    console.log 'edit'
    api.observers.read(params.email).done (sub) ->
      updateSub sub
      editModal.modal "show"

  pickData = (data) ->
    _.pick data, 'email', 'tagList'

  updateSub = (data) ->
    data = pickData data
    console.log "update", data
    _.extend $scope, {}, data
    $scope.$digest()

  $scope.isNew = ->
    !_.find $scope.subs, (s) -> s.email is $scope.email

  # save / create
  $scope.commitSub = ->
    console.log 'commit!'

    #validate all inputs
    $element.find('form').validate (r) ->
      return unless r

      #get fields
      data = pickData $scope

      #create or edit...
      req = if $scope.isNew()
        api.observers.create(data)
      else 
        api.observers.update(data.email, data)

      #on success
      req.done ->
        editModal.modal 'hide'
        $scope.$root.$broadcast 'subs'




