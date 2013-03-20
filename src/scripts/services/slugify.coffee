CronEngine.factory "slugify", ->
  (str) -> str and str.replace(/\s+/,'-').toLowerCase()