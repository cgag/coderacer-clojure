// Generated by CoffeeScript 1.3.3
(function() {
  var codeHtml, codeJoin, codeSamples, codeSplit, entify, entityMap, j, preEscape, unentify, wrapCode;

  codeHtml = function(json) {
    var pages, prop;
    pages = json["query"]["pages"];
    for (prop in pages) {
      return pages[prop]["revisions"][0]["*"];
    }
  };

  codeSamples = function(html) {
    var arr, codeReg, samples;
    codeReg = /<lang.*?>([.\s\S]*?)<\/lang>/g;
    samples = [];
    while ((arr = codeReg.exec(html))) {
      samples.push(arr[1]);
    }
    return samples;
  };

  j = function(s) {
    return JSON.stringify(s);
  };

  codeSplit = function(code) {
    var char, token, tokens, _i, _len;
    tokens = [];
    token = "";
    for (_i = 0, _len = code.length; _i < _len; _i++) {
      char = code[_i];
      if (char === " ") {
        token = token.concat(char);
        tokens.push(token);
        token = "";
      } else if (char === "\n") {
        token = token.concat(char);
        tokens.push(token);
        token = "";
      } else {
        token = token.concat(char);
      }
    }
    tokens.push(token);
    return tokens;
  };

  codeJoin = function(splitCode) {
    var output, token, _i, _len;
    output = "";
    for (_i = 0, _len = splitCode.length; _i < _len; _i++) {
      token = splitCode[_i];
      if (token[token.length - 1] !== "\n") {
        output += token + " ";
      } else {
        output += token;
      }
    }
    return output;
  };

  wrapCode = function(code) {
    var i, output, splitCode, token, _i, _len;
    splitCode = codeSplit(code);
    output = "";
    for (i = _i = 0, _len = splitCode.length; _i < _len; i = ++_i) {
      token = splitCode[i];
      output += ("<span id=\"token-" + i + "\">") + token + "</span>";
    }
    return output;
  };

  entityMap = {
    "<": "&lt;",
    ">": "&gt;",
    "&": "&amp;"
  };

  entify = function(char) {
    return entityMap[char] || char;
  };

  unentify = function(s) {
    var k, v;
    for (k in entityMap) {
      v = entityMap[k];
      if (s === v) {
        return k;
      }
    }
    return s;
  };

  preEscape = function(preCode) {
    var char, output, _i, _len;
    output = "";
    for (_i = 0, _len = preCode.length; _i < _len; _i++) {
      char = preCode[_i];
      output += entify(char);
    }
    return output;
  };

  jQuery(function() {
    var currentToken, escapedSample, handleInput, html, inputToken, resp, sample, setMatch, setMiss, tokens, updateCurrentCSS;
    resp = {
      "query": {
        "pages": {
          "1514": {
            "pageid": 1514,
            "ns": 0,
            "title": "Hello world\/Text",
            "revisions": [
              {
                "*": "=={{header|C}}==\n{{works with|gcc|4.0.1}}\n<lang c>#include <stdlib.h>\n#include <stdio.h>\n\nint main(void)\n{\n  printf(\"Goodbye, World!\\n\");\n  return EXIT_SUCCESS;\n}<\/lang>\nOr:\n<lang c>#include <stdlib.h>\n#include <stdio.h>\n\nint main(void)\n{\n  puts(\"Goodbye, World!\");\n  return EXIT_SUCCESS;\n}<\/lang>"
              }
            ]
          }
        }
      },
      "query-continue": {
        "revisions": {
          "rvstartid": 137809
        }
      }
    };
    html = codeHtml(resp);
    $("body").append("<pre>" + html + "</pre>");
    sample = codeSamples(html)[0];
    tokens = codeSplit(sample);
    console.log(tokens);
    escapedSample = preEscape(sample);
    $("#target-text").append("<pre>" + wrapCode(escapedSample) + "</pre>");
    inputToken = "";
    currentToken = 0;
    $("#token-" + currentToken).addClass("current");
    $("#token-" + currentToken).addClass("match");
    setMatch = function() {
      $("#token-" + currentToken).addClass("match");
      $("#token-" + currentToken).removeClass("miss");
      return console.log("currentToken: " + currentToken);
    };
    setMiss = function() {
      console.log("currentToken: " + currentToken);
      $("#token-" + currentToken).addClass("miss");
      return $("#token-" + currentToken).removeClass("match");
    };
    updateCurrentCSS = function() {
      $("#token-" + currentToken).addClass("currrent");
      $("#token-" + (currentToken - 1)).removeClass("currrent");
      return $("#token-" + (currentToken - 1)).removeClass("match");
    };
    handleInput = function(e) {
      if (e.which === 8 && inputToken.length > 0) {
        inputToken = inputToken.slice(0, inputToken.length - 1);
      } else if (e.type === "keypress") {
        inputToken = inputToken.concat(unentify(String.fromCharCode(e.which)));
      }
      console.log("inputToken in handleInput topLevel: " + inputToken);
      if (tokens[currentToken].slice(0, inputToken.length) === inputToken) {
        if (inputToken.length === tokens[currentToken].length) {
          console.log("inputToken.length == tokens[currentToken].length: " + tokens[currentToken].length);
          currentToken += 1;
          inputToken = "";
          updateCurrentCSS();
          $("#typing-area").val("");
          e.preventDefault();
        }
        console.log("currentToken: " + currentToken);
        console.log("inputToken setMatch level: " + inputToken);
        console.log("tokens[currentToken].slice: " + tokens[currentToken].slice(0, inputToken.length));
        setMatch();
      } else {
        console.log("missed");
        setMiss();
      }
      $("#entered-word").text("entered: " + inputToken + "\n");
      return $("#target-word").text("target: " + tokens[currentToken] + "\n");
    };
    $("#typing-area").keypress(handleInput);
    $("#typing-area").keydown(handleInput);
    $("body").append("=====<br /><pre>" + escape(codeJoin(tokens)) + "</pre>");
    return $("body").append("=====<br /><pre>" + preEscape(codeJoin(tokens)) + "</pre>");
  });

}).call(this);
