#debug = true

j = (s) ->
  JSON.stringify(s)

# later
#removeTrailingWhiteSpace = (tokens) ->
  #for token in tokens
    #token.replace(/(\s*)\n/, "" + "\n")
    #???

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
    if token[token.length - 1] != "\n"
      output += token + " "
    else
      output += token
  output


wrapCode = (code) ->
  splitCode = codeSplit(code)
  output = ""
  for token, i in splitCode
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
  output

window.allWhiteSpace = (s) ->
  $.trim(s).length == 0

window.getProblems = () ->
  html = $.trim($.ajax({
            url: "http://localhost:8000/data/parsed/"
            dataType: "html"
            async: false}).responseText)
  console.log("html: " + html)
  arr = []
  $(html).find("a").each((i, el) -> arr.push(el.text.slice(0, el.text.length - 1)))
  arr

#jQuery ->
  #alert("hi")
  #problems = getProblems
  #$.each(problems, (value) ->
    #alert("valie: " + value)
    #$('#problem').append($('<option>', { value : value }).text(value.replace('_', ' '))))

window.race = ->
  getProblems = () ->
  getProblems()
  samples = []

  problems = ["Anonymous_recursion", "Anagrams", "Ackermann_function"]
  languages = ["c", "ruby", "clojure"]

  lang = $("#lang option:selected").val()
  problem = $("#problem option:selected").val()

  console.log("problem: " + problem)
  console.log("lang: " + lang)

  sample = "hello"
  console.log("sample: " + sample)
  sample = $.trim($.ajax({
            url: "http://localhost:8000/data/parsed/#{problem}/#{lang}",
            dataType: "text"
            async: false}).responseText)
  console.log("sample: " + sample)

  #samples = [
    #$.trim($.ajax({
      #url: "http://localhost:8000/data/parsed/Anonymous_recursion/clojure",
      #dataType: "text"
      #async: false
    #}).responseText),
    #$.trim($.ajax({
      #url: "http://localhost:8000/data/parsed/Anagrams/clojure",
      #dataType: "text"
      #async: false
    #}).responseText)]



  #code = $.ajax({
    #url: "http://localhost:8000/data/parsed/99_Bottles_of_Beer/fortran",
    #dataType: "text"
    #async: false
  #}).responseText

  #html = codeHtml(resp)

  #sample = samples[2] #code # codeSamples(html)[0] #preEscape

  tokens = codeSplit(sample)
  escapedSample = preEscape(sample)
  #tokens[0] = "#include"
  $("#code-text").append("<pre><span id=\"code-style\">" + wrapCode(escapedSample) + "</span></pre>")

  inputToken = ""
  currentToken = 0

  $("#token-#{currentToken}").addClass("current")
  $("#token-#{currentToken}").addClass("match")

  setMatch = (currentToken) ->
    $("#token-#{currentToken}").addClass("match")
    $("#token-#{currentToken}").removeClass("miss")

  setMiss = (currentToken) ->
    $("#token-#{currentToken}").addClass("miss")
    $("#token-#{currentToken}").removeClass("match")

  updateCurrentCSS = (currentToken) ->
    console.log("currentToken: " + tokens[currentToken])
    if allWhiteSpace(tokens[currentToken])
      $("#token-#{currentToken}").addClass("whitespace")
    $("#token-#{currentToken}").addClass("current")
    $("#token-#{currentToken - 1}").removeClass("current")
    $("#token-#{currentToken - 1}").removeClass("match")
    $("#token-#{currentToken - 1}").removeClass("whitespace")

  handleInput = (e) ->
    if e.which == 8 && inputToken.length > 0
      inputToken = inputToken.slice(0, inputToken.length - 1)
    else if e.which == 9
      while allWhiteSpace(tokens[currentToken])
        currentToken += 1
        inputToken = ""
        updateCurrentCSS(currentToken)
        $("#textInput").val("")
      e.preventDefault()
    else if e.which == 13
      inputToken = inputToken.concat("\n")
      e.preventDefault()
    else if e.type == "keypress"
      inputToken = inputToken.concat(unentify(String.fromCharCode(e.which)))

    if tokens[currentToken].slice(0, inputToken.length) == inputToken
      if inputToken.length == tokens[currentToken].length
        currentToken += 1
        inputToken = ""
        updateCurrentCSS(currentToken)
        $("#textInput").val("")
        e.preventDefault()
      setMatch(currentToken)
    else
      setMiss(currentToken)

    if debug
      $("#entered-word").text("entered: " + inputToken + "\n")
      $("#target-word").text("target: " + tokens[currentToken] + "\n")

  $("#textInput").keypress(handleInput)
  $("#textInput").keydown(handleInput)

  if debug
    $("body").append("=====<br /><pre>" + escape(codeJoin(tokens)) + "</pre>")
    $("body").append("=====<br /><pre>" + preEscape(codeJoin(tokens)) + "</pre>")
