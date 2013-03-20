"use strict"

# Array Remove - By John Resig (MIT Licensed)
Array::remove = (from, to) ->
  rest = @slice((to or from) + 1 or @length)
  @length = (if from < 0 then @length + from else from)
  @push.apply this, rest

#new application (aka module)
window.CronEngine = angular.module 'cron-engine', []

