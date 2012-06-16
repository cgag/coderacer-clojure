(ns rosettacode.core
  (:require [clj-http.client :as client]
            [clojure.string :as s]
            [cheshire.core :as json])
  (:import [java.net URLEncoder URL])
  (:use [net.cgrand.enlive-html]
        [com.ashafa.clutch :only [create-database with-db
                                  put-document get-document
                                  delete-document]]
        [clojure.pprint]))

(defn fetch-html [url]
  (html-resource (java.net.URL. url))) 
(def root-url "http://rosettacode.org")
(def query-base-url "http://rosettacode.org/mw/api.php?format=json&action=query&prop=revisions&rvprop=content&rvlimit=1&gsrlimit=1&generator=search&rvexpandtemplates=1&gsrsearch=")
(def languages-html (fetch-html "http://rosettacode.org/wiki/Category:Programming_Languages"))

(def languages (select languages-html [:#mw-subcategories :li :a]))
(def lang-links (select languages [  #{(attr= :title "Category:C")
                                       (attr= :title "Category:Clojure")
                                       (attr= :title "Category:Java")
                                       (attr= :title "Category:Lisp")
                                       (attr= :title "Category:C++")
                                       (attr= :title "Category:Python")
                                       (attr= :title "Category:Objective-C")}]))

(defn get-url [link]
  (str root-url (:href (:attrs link))))

(def new-urls (map get-url lang-links))
(def problems-html (map fetch-html new-urls))

(defn problems [html]
  (let [links (select html [:#mw-pages :a])]
    (map (comp :title :attrs) links)))

(def problems-list (mapcat problems problems-html))
(def problems-set (into #{} problems-list))

(defn raw-problem-data [problem-title]
  (let [url (str query-base-url (URLEncoder/encode problem-title))
        resp (:body (client/get url))
        json (json/parse-string resp true)
        pages (-> json :query :pages)
        page-key (first (keys pages))]
    (-> pages page-key :revisions first :*)))

(defn -main
  [& args]
  "hello")
