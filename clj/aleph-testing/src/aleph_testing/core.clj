(ns aleph-testing.core)

(defn test-fn [& args]
  (map (partial * 5) args))

(defn -main
  "I don't do a whole lot."
  [& args]
  (println "Hello, World!"))
