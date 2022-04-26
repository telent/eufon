(local {: bar : indicator : stylesheet  : run} (require :blinkenlicht))

(local {: view} (require :fennel))

(local iostream (require :blinkenlicht.iostream))
;(local modem (require :blinkenlicht.modem))

;(local uplink (require :blinkenlicht.metric.uplink))
;(local battery (require :blinkenlicht.metric.battery))
(local cpustat (require :blinkenlicht.metric.cpustat))

(stylesheet "licht.css")

(fn battery-icon-codepoint [status percent]
  (if (= status "Charging") 0xf0e7
      (> percent 90) 0xf240                ;full
      (> percent 60) 0xf241                ;3/4
      (> percent 40) 0xf242                ;1/2
      (> percent 15) 0xf243                ;1/4
      (>= percent 0)  0xf244                ;empty
      ; 0xf377         ; glyph not present in font-awesome free
      ))

(fn wlan-quality-class [quality]
  (if (< -50 quality) "p100"
      (< -67 quality) "p75"
      (< -70 quality) "p50"
      (< -80 quality) "p25"
      "p0"))

(fn spawn []
  true)

(bar
 {
  ;; bar must be full width to set up an "exclusive zone" (moves
  ;; other windows out of the way), otherwise it will display on
  ;; to of whatever's on the screen already
  :anchor [:top :right :left]
  :orientation :horizontal
  :gravity :end
  :classes ["hey"]
  :indicators
  [
   (indicator {
               :wait-for { :interval 4000 }
               :refresh #{:text (os.date "%H:%M")}
               })

   ]})

(run)
