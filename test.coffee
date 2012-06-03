#todo:
 # escape charcters in the target-text div
 # translate input special characters to entities
 # get rid of hardcoding on token[0] (removed trailing \n)
 # toggle css when updating current token

codeHtml = (json) ->
  pages = json["query"]["pages"]
  for prop of pages
    return pages[prop]["revisions"][0]["*"]


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
      #if token.length == 0 || token[token.length - 1] == " "
        #token = token.concat(" ")
      #else
      token = token.concat(char)
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
    #console.log("Token:" + token)
    if token[token.length - 1] != "\n"
      output += token + " "
      #console.log("outout:" + output)
    else
      output += token
  output


wrapCode = (code) ->
  splitCode = codeSplit(code)
  output = ""
  for token, i in splitCode
    #console.log("Token:" + token)
    #if token[token.length - 1] != "\n"
      #output += "<span id=\"token-#{i}\">" + token + " " + "</span>"
      ##console.log("outout:" + output)
    #else
    output += "<span id=\"token-#{i}\">" + token + "</span>"
  output


entityMap = {
    "<": "&lt;",
    ">": "&gt;",
    "&": "&amp;"
  }

entify = (char) ->
  entityMap[char] || char

unentify = (s) ->
  for k,v of entityMap
    return k if s == v
  return s

preEscape = (preCode) ->
  output = ""
  for char in preCode
    output += entify(char)
    #if char == "<"
      #output = output.concat("&lt;")
    #else if char == ">"
      #output = output.concat("&gt;")
    #else if char == "&"
      #output = output.concat("&amp;")
    #else
      #output = output.concat(char)
  output


jQuery ->
  resp = {"query":{"pages":{"1514":{"pageid":1514,"ns":0,"title":"Hello world\/Text","revisions":[{"*":"=={{header|C}}==\n{{works with|gcc|4.0.1}}\n<lang c>#include <stdlib.h>\n#include <stdio.h>\n\nint main(void)\n{\n  printf(\"Goodbye, World!\\n\");\n  return EXIT_SUCCESS;\n}<\/lang>\nOr:\n<lang c>#include <stdlib.h>\n#include <stdio.h>\n\nint main(void)\n{\n  puts(\"Goodbye, World!\");\n  return EXIT_SUCCESS;\n}<\/lang>"}]}}},"query-continue":{"revisions":{"rvstartid":137809}}} 
  html = codeHtml(resp)
  $("body").append("<pre>" + html + "</pre>")

  sample = codeSamples(html)[0] #preEscape

  #console.log(sample)
  tokens = codeSplit(sample)
  console.log(tokens)
  escapedSample = preEscape(sample)
  #tokens[0] = "#include"
  $("#target-text").append("<pre>" + wrapCode(escapedSample) + "</pre>")

  inputToken = ""
  currentToken = 0
  $("#token-#{currentToken}").addClass("current")
  $("#token-#{currentToken}").addClass("match")

  setMatch = () ->
    $("#token-#{currentToken}").addClass("match")
    $("#token-#{currentToken}").removeClass("miss")
    console.log("currentToken: " + currentToken)

  setMiss = () ->
    console.log("currentToken: " + currentToken)
    $("#token-#{currentToken}").addClass("miss")
    $("#token-#{currentToken}").removeClass("match")

  updateCurrentCSS = () ->
    $("#token-#{currentToken}").addClass("currrent")
    $("#token-#{currentToken - 1}").removeClass("currrent")
    $("#token-#{currentToken - 1}").removeClass("match")


  handleInput = (e) ->
    if e.which == 8 && inputToken.length > 0
      inputToken = inputToken.slice(0, inputToken.length - 1)
    else if e.type == "keypress"
      inputToken = inputToken.concat(unentify(String.fromCharCode(e.which)))

    console.log("inputToken in handleInput topLevel: " + inputToken)
    if tokens[currentToken].slice(0, inputToken.length) == inputToken
      if inputToken.length == tokens[currentToken].length
        console.log("inputToken.length == tokens[currentToken].length: " + tokens[currentToken].length)
        currentToken += 1
        inputToken = ""
        updateCurrentCSS()
        $("#typing-area").val("")
        e.preventDefault()
      console.log("currentToken: " + currentToken)
      console.log("inputToken setMatch level: " + inputToken)
      console.log("tokens[currentToken].slice: " + tokens[currentToken].slice(0, inputToken.length))
      setMatch()
    else
      console.log("missed")
      setMiss()

    $("#entered-word").text("entered: " + inputToken + "\n")
    $("#target-word").text("target: " + tokens[currentToken] + "\n")

  $("#typing-area").keypress(handleInput)
  $("#typing-area").keydown(handleInput)


  #console.log(tokens)
  $("body").append("=====<br /><pre>" + escape(codeJoin(tokens)) + "</pre>")
  $("body").append("=====<br /><pre>" + preEscape(codeJoin(tokens)) + "</pre>")

  #console.log(wrapCode(sample))
