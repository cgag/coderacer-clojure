This was made for a hackathan (hack the midwest).  We intended to make a version of [typeracer](http://play.typeracer.com/) using code samples instead of prose. 

Naturally things took longer than expected and we only really got as far being able to track/follow along with the code being typed.  You can see it here: [coderacer](http://coderacer.curtis.io).  

I ([Curtis](http://curtis.io)) wrote all the coffeescript (coderacer.coffee) for the code input, [Caleb Hyde](https://twitter.com/Hedonistica) wrote the code to download and parse coding problem samples from [Rosetta Code](http://rosettacode.org/wiki/Rosetta_Code), the results of which can be found in `data/parsed`.

I later wrote some clojure to download more samples and store them in couchdb.  I never got around to actual making use of the db once I had it though, maybe one day.
