(local {: bar : indicator : stylesheet  : run} (require :blinkenlicht))
(local {: view} (require :fennel))

(local metric (require :metric))

(stylesheet "licht.css")

(fn battery-icon-codepoint [status percent]
  (if ; (= status "Charging") 0xf376 ; glyph not present in font-awesome free
      (> percent 90) 0xf240                ;full
      (> percent 60) 0xf241                ;3/4
      (> percent 40) 0xf242                ;1/2
      (> percent 15) 0xf243                ;1/4
      (>= percent 0)  0xf244                ;empty
      ; 0xf377         ; glyph not present in font-awesome free
      ))


(fn spawn []
  true)

(bar
 {
  :anchor [:top :right]
  :orientation :horizontal
  :classes ["hey"]
  :indicators
  [
   (indicator {
               :interval 200
               :icon #(if (> (metric.loadavg) 2) "face-sad" "face-smile")
               })
   ;; (let [f (io.open "/tmp/statuspipe" "r")]
   ;;   (indicator {
   ;;               :poll [f]
   ;;               :text #((f:read):sub 1 10)
   ;;               }))
   (indicator {
               :interval (* 10 1000)
               :classes ["yellow"]
               :text #(let [{:power-supply-energy-full full
                             :power-supply-energy-now now
                             :power-supply-status status} (metric.battery)
                            percent (math.floor (* 100 (/ (tonumber now) (tonumber full))))
                            icon-code (battery-icon-codepoint status percent)]
                        (string.format "%s %d%%" (utf8.char icon-code) percent))
               })
   (indicator {
               :interval 1000
               :text #(os.date "%H:%M")
               })
   ]})

(run)
