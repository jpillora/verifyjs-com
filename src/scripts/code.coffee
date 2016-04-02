setupCode = ->
  console.log "setup"
  insertCode = (container, pre) ->
    return  if container.length is 0 or pre.length is 0
    content = container.html()
    lines = content.split("\n")
    indentation = undefined
    content = ""
    i = 0
    l = lines.length
    while i < l
      line = lines[i]
      if i > 0 and i < l - 1
        if indentation is `undefined`
          m = line.match(/^(\ *)/)
          indentation = m[1]  if m
        line = line.replace(new RegExp("^" + indentation), "")
        content += line + "\n"
      ++i
    pre.append prettify(content)
  # setupCodeSnippets
  $(".demo").each ->
    demo = $(this)
    # console.log "load demo: %s", demo.attr 'data-nav-anchor'
    htmlDemo = demo.find("div[data-html]")
    htmlPre = demo.find("pre[data-html]")
    scriptDemo = demo.find("script[data-script]")
    scriptPre = demo.find("pre[data-script]")
    insertCode htmlDemo, htmlPre
    insertCode scriptDemo, scriptPre
  # setupHighlightTable
  $(".highlight-col3-table tbody tr").each ->
    codeCol = $(this).children().eq(2)
    codeCol.html prettify(codeCol.html())
