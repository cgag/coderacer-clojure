(ns rosettacode.core
  (:require [clj-http.client :as client])
  (:use [net.cgrand.enlive-html]
        [com.ashafa.clutch :only [create-database with-db
                                  put-document get-document
                                  delete-document]]
        [clojure.string :only [split]]))

(defn fetch-html [url]
  (html-resource (java.net.URL. url)))

(def root-url "http://rosettacode.org")
(def languages-html (fetch-html "http://rosettacode.org/wiki/Category:Programming_Languages"))

(def languages (select languages-html [:#mw-subcategories :li :a]))
(def lang-links (select languages [  #{(attr= :title "Category:C")
                                       (attr= :title "Category:Clojure")
                                       (attr= :title "Category:Java")
                                       (attr= :title "Category:C++")
                                       (attr= :title "Category:Python")
                                       (attr= :title "Category:Objective-C")}]))

(def new-urls (map #(str root-url (:href (:attrs %))) lang-links))
(def problems-html (map fetch-html new-urls))

(defn problems [html]
  (let [links (select html [:#mw-pages :a])]
    (map (comp :href :attrs) links)))

(def problems-list (mapcat problems problems-html))
(def problems-set (into #{} problems-list))

(defn edit-url [href]
  (str root-url 
       "/mw/index.php?title="
       (peek (split href #"/"))
       "&action=edit"))

(def edit-urls (map edit-url problems-set))

(defn -main
  [& args]
  (spit "problems" (pr-str problems-set)))
