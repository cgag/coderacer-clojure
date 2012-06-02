s = <<-EOH
<textarea id="wpTextbox1" name="wpTextbox1" cols="80" rows="25" readonly="">=={{header|ALGOL 68}}==
{{works with|ALGOL 68|Standard - no extensions to language used}}
{{works with|ALGOL 68G|Any - tested with release mk15-0.8b.fc9.i386}}
&lt;!-- {{not works with|ELLA ALGOL 68|Any (with appropriate job cards) - tested with release 1.8.8d.fc9.i386 - printf has been removed}} -->
&lt;lang algol68>main:(
   FOR bottles FROM 99 TO 1 BY -1 DO
     printf(($z-d" bottles of beer on the wall"l$, bottles));
     printf(($z-d" bottles of beer"l$, bottles));
     printf(($"Take one down, pass it around"l$));
     printf(($z-d" bottles of beer on the wall"ll$, bottles-1))
   OD
)&lt;/lang></textarea>
EOH

s2 = <<-EOH
<textarea id="wpTextbox1" name="wpTextbox1" cols="80" rows="25" readonly="">=={{header|Clojure}}==
&lt;lang lisp>(defn verse [n]
  (printf
"%d bottles of beer on the wall
%d bottles of beer
Take one down, pass it around
%d bottles of beer on the wall\n\n" n n (dec n)))

(defn sing [start]
  (dorun (map verse (range start 0 -1))))&lt;/lang></textarea>
EOH

samples = [s, s2]

samples.each do |sample|
  code = sample.scan(/&lt;lang.*?>(.*)&lt;\/lang/m)[0][0]
  code.split("\n").each do |token|
    puts token
  end
  puts "------"
end


