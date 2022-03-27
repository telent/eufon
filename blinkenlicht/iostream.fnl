(local posix (require :posix))
(local fcntl (require :posix.fcntl))

(fn open [name direction]
  (let [flags (match direction
                :r posix.O_RDONLY
                :w (+ posix.O_WRONLY posix.O_CREAT))
        fd (posix.open name flags)]
    (fcntl.fcntl fd fcntl.F_SETFL fcntl.O_NONBLOCK)
    {
     :read #(posix.unistd.read fd $2)   ;XXX needs to check for eof
     :close #(posix.unistd.close fd)
     :fileno fd
     }))

{: open }
