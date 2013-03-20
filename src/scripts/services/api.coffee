CronEngine.factory "api", ->

  console.log "init api"

  #Build API
  api = new $.RestClient("http://cron.think.edu.au:8080/api/",
    stringifyData: true
    # cache: 60
    verbs:
      update: "POST"
  )
  api.add "cronjobs"
  api.cronjobs.addVerb "trigger", "POST"
  api.cronjobs.add "execs"
  api.add "observers"
  api