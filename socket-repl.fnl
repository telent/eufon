(local { : fdopen } (require "posix.stdio"))
(local fcntl (require "posix.fcntl"))
(local unistd (require "posix.unistd"))
(local socket (require "posix.sys.socket"))
(local { : repl } (require :fennel))

(fn watch-fd [fd mode handler]
  (kiwmi:event_loop_add_fd fd mode handler))

(fn unix-socket-listener [pathname on-connected]
  (let [sa {:family socket.AF_UNIX
            :path pathname
            }
        fd (socket.socket socket.AF_UNIX socket.SOCK_STREAM 0)]
    (socket.bind fd sa)
    (socket.listen fd 5)
    (watch-fd
     fd fcntl.O_RDWR
     #(let [connected-fd (socket.accept $1)]
        (on-connected connected-fd)))
    ))

(fn start [pathname]
  (print pathname)
  (unistd.unlink pathname)
  (unix-socket-listener
   pathname
   (fn [fd]
     (let [sock (fdopen fd "w+")
           repl-coro (coroutine.create repl)]
       (print :fd fd :sock sock)
       (watch-fd fd fcntl.O_RDONLY
                 #(coroutine.resume repl-coro (unistd.read $1 1024)))
       (coroutine.resume repl-coro
                         {:readChunk
                          (fn [{: stack-size}]
                            (sock:write
                             (if (> stack-size 0) ".." ">> "))
                            (sock:flush)
                            (coroutine.yield))
                          :onValues
                          (fn [vals]
                            (sock:write (table.concat vals "\t"))
                            (sock:write "\n"))
                          :onError
                          (fn [errtype err]
                            (sock:write
                             (.. errtype " error: " (tostring err) "\n")))
                          })))))


{ : start }
