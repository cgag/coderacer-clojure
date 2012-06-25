(ns aleph-testing.core
  (:use [lamina.core]
        [aleph.http]))

(defn hello-world [channel request]
  (future
    (Thread/sleep 5000)
    (enqueue channel
             {:status 200
              :headers {"content-type" "text/html"}
              :body "With future"})))


(defn sync-hello-world [request]
  (Thread/sleep 5000)
  {:status 200
   :headers {"content-type" "text/html"}
   :body "butts"})


(defn stream-numbers [ch]
  (future
    (dotimes [i 5]
      (dotimes [i 3000]
        (enqueue ch (str i)))
      (Thread/sleep 2000))
    (close ch)))

(defn handler [request]
  (let [stream (channel)]
    (stream-numbers stream)
    {:status 200
     :headers {"content-type" "text/plain"}
     :body stream}))

(def wrapped-handler (wrap-ring-handler handler))
(def wrapped-sync (wrap-ring-handler sync-hello-world))

(def server (start-http-server #'hello-world {:port 8080}))

(defn stop-server [server-fn]
  (server-fn))

(defn -main
  "I don't do a whole lot."
  [& args]
  (println "Hello, World!"))

