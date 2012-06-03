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
  #console.log(j(sample.split(" ")))

  console.log(sample)
  splitCode = codeSplit(sample)
  console.log(splitCode)
  $("body").append("=====<br /><pre>" + escape(codeJoin(splitCode)) + "</pre>")
  $("body").append("=====<br /><pre>" + preEscape(codeJoin(splitCode)) + "</pre>")
