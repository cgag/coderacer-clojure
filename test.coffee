codeHtml = (json) ->
  json["query"]["pages"]["1514"]["revisions"][0]["*"]

codeSamples = (html) ->
  codeReg = /<lang.*?>([.\s\S]*?)<\/lang>/g
  samples = []
  while (arr = codeReg.exec(html))
    samples.push(arr[1])
  samples #unnecessary?

j = (s) ->
  JSON.stringify(s)

codeSplit = (code) ->
  tokens = []
  token = ""
  for char in code
    if char == " "
      if token.length == 0 || token[token.length - 1] == " "
        token = token.concat(" ")
      else
        tokens.push(token)
        token = ""
    else if char == "\n"
      token = token.concat(char)
      tokens.push(token)
      token = ""
    else
      token = token.concat(char)
  tokens.push(token)
  tokens

codeJoin = (splitCode) ->
  output = ""
  for token in splitCode
    console.log("Token:" + token)
    if token[token.length - 1] != "\n"
      output += token + " "
      console.log("outout:" + output)
    else
      output += token
  output


wrapCode = (code) ->
  splitCode = codeSplit(code)
  output = ""
  for token, i in splitCode
    console.log("Token:" + token)
    if token[token.length - 1] != "\n"
      output += "<span id=\"token-#{i}\">" + token + " " + "</span>"
      console.log("outout:" + output)
    else
      output += "<span id=\"token-#{i}\">" + token + "</span>"
  output


preEscape = (preCode) ->
  output = ""
  for char in preCode
    if char == "<"
      output = output.concat("&lt;")
    else if char == ">"
      output = output.concat("&gt;")
    else if char == "&"
      output = output.concat("&amp;")
    else
      output = output.concat(char)
  output


jQuery ->
  resp = {"query":{"pages":{"1514":{"pageid":1514,"ns":0,"title":"Hello world\/Text","revisions":[{"*":"=={{header|C}}==\n{{works with|gcc|4.0.1}}\n<lang c>#include <stdlib.h>\n#include <stdio.h>\n\nint main(void)\n{\n  printf(\"Goodbye, World!\\n\");\n  return EXIT_SUCCESS;\n}<\/lang>\nOr:\n<lang c>#include <stdlib.h>\n#include <stdio.h>\n\nint main(void)\n{\n  puts(\"Goodbye, World!\");\n  return EXIT_SUCCESS;\n}<\/lang>"}]}}},"query-continue":{"revisions":{"rvstartid":137809}}} 
  html = codeHtml(resp)
  $("body").append("<pre>" + html + "</pre>")

  sample = codeSamples(html)[0]

  console.log(sample)
  tokens = codeSplit(sample)

  $("#target-text").append("<pre>" + wrapCode(sample) + "</pre>")

  wordSoFar = ""
  currentToken = 0
  $("#token-#{currentToken}").addClass("current")
  $("#token-#{currentToken}").addClass("match")

  setMatch = () ->
    $("#token-#{currentToken}").addClass("match")
    $("#token-#{currentToken}").removeClass("miss")
 
  setMiss = () ->
    $("#token-#{currentToken}").addClass("miss")
    $("#token-#{currentToken}").removeClass("match")
 

  handleInput = (e) ->
    if e.which == 8 && wordSoFar.length > 0
      wordSoFar = wordSoFar.slice(0, wordSoFar.length - 1)
      #$("#target-text > pre").append(" " + wordSoFar)
    else if e.type == "keypress"
      wordSoFar = wordSoFar.concat(String.fromCharCode(e.which))

    #$("#target-text > pre").append(" " + wordSoFar)
    if tokens[currentToken].slice(0, wordSoFar.length) == wordSoFar
      setMatch()
          #$("#target-text > pre").append(" match" + "\n")
    else
      setMiss()
      #$("#target-text > pre").append(" miss" + "\n")

    $("#entered-word").text("entered: " + wordSoFar + "\n")
    $("#target-word").text("target: " + tokens[currentToken] + "\n")

  $("#typing-area").keypress(handleInput)
  $("#typing-area").keydown(handleInput)


  console.log(tokens)
  $("body").append("=====<br /><pre>" + escape(codeJoin(tokens)) + "</pre>")
  $("body").append("=====<br /><pre>" + preEscape(codeJoin(tokens)) + "</pre>")

  console.log(wrapCode(sample))
