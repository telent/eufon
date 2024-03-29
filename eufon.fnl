;; -*- mode: Fennel;

(local { : view } (require :fennel))

(local texture (require :texture))
(local matrix (require :matrix))
(local socket-repl (require :socket-repl))

(local app-state
       {
        :in-overview false
        :focus-view nil
        :views []
        })

(let [repl-socket-name
      (..
       (: (os.getenv "XDG_RUNTIME_DIR") :gsub "/$" "")
       "/kiwmi-repl."
       (os.getenv "WAYLAND_DISPLAY")
       ".socket"
       )]
  (socket-repl.start repl-socket-name))

(fn resize-wayland-backend [output]
  (when (string.find (output:name) "^WL-")
    (output:set_mode 360 720 0)))

(fn kill-window []
  (print "DIE")
  true)

(fn launch []
  (print "WHOOSH")
  true)

(fn eufon-path [f]
  (.. (os.getenv "EUFON_PATH") "/" f))

(fn show-overview []
  (let [facets 64
        angle (/ (* 2 math.pi) facets)
        scale 0.6
        y-offset (+ (* 1 680)
                    (/ (* 360 facets) (* 2 math.pi)))
        ]
    (each [i view (ipairs app-state.views)]
      (doto view
        (: :set_matrix
           (-> matrix.identity
               (matrix.scale scale scale)
               (matrix.translate (*  2 180) (+ y-offset))
               (matrix.rotate (/ (* (- i 2
                                       ) angle) 1))
               (matrix.translate (* -2 180) (- y-offset))
               (matrix.translate 120 150)
               ))
        (: :show)))))


(fn hide-overview []
  (each [k view (pairs app-state.views)]
    (view:set_matrix matrix.identity)
    (if (= (view:id) (app-state.focus-view:id))
        (doto view
          (: :show)
          (: :focus))
        (view:hide))))

(fn carousel []
  (let [was app-state.in-overview]
    (if was
        (hide-overview)
        (show-overview))
    (: (kiwmi:active_output) :redraw)
    (tset app-state :in-overview (not was))))

(fn placements [output]
  (let [(width height) (output:size)
        bar-height (/ height 15)]
    {

     :application {
           :x 0
           :y 0
           :w width
           :h (- height (* bar-height 1.1))
           }
     :bar {
           :x 0
           :y (- height (* bar-height 1.1))
           :w width
           :h (* bar-height 1.1)
           }
     :kill {
            :x (- (* width 0.25) (/ bar-height 2))
            :y (- height bar-height)
            :w bar-height
            :h bar-height
            :on-press kill-window
            }
     :launch {
              :x (- (* width 0.5) (/ bar-height 2))
              :y (- height bar-height)
              :w bar-height
              :h bar-height
              :on-press launch
              }
     :overview {
                :x (- (* width 0.75) (/ bar-height 2))
                :y (- height bar-height)
                :w bar-height
                :h bar-height
                :on-press carousel
                }
     }))

(fn choose-view-at [x y]
  (let [view (kiwmi:view_at x y)]
    (tset app-state :focus-view view)
    (tset app-state :in-overview false)
    (hide-overview)
    true))

(let [cursor (kiwmi:cursor)]
  (cursor:on "button_up"
             (fn [button-id]
               (when app-state.in-overview
                 (let [geom (placements (kiwmi:active_output))
                       (x y) (cursor:pos)]
                   (if (<  y geom.application.h)
                       (choose-view-at x y)
                       false))))))

(kiwmi:on
 "output"
 (fn [output]
   (resize-wayland-backend output)
   (let [(width height) (output:size)
         r (output:renderer)
         kill (texture.from-file r (eufon-path "close-window.png"))
         launch (texture.from-file r (eufon-path "launcher.png"))
         overview (texture.from-file r (eufon-path "carousel.png"))]
     (output:on "render"
                (fn [{: output : renderer}]
                  (let [buttons (placements output)]
                    (renderer:draw_rect :#77000077
                                        buttons.bar.x buttons.bar.y
                                        buttons.bar.w buttons.bar.h)
                    (renderer:draw_texture
                     kill
                     matrix.identity
                     buttons.kill.x buttons.kill.y
                     0.7)
                    (renderer:draw_texture
                     launch
                     matrix.identity
                     buttons.launch.x buttons.launch.y
                     0.7)
                    (renderer:draw_texture
                     overview
                     matrix.identity
                     buttons.overview.x buttons.overview.y
                     0.7)))))))


(let [cursor (kiwmi:cursor)]
  (cursor:on "button_down"
             (fn [button]
               (let [(x y) (cursor:pos)]
                 (each [name attribs (pairs (placements (kiwmi:active_output)))]
                   (if (and
                        (<= attribs.x x)
                        (< x (+ attribs.x attribs.w))
                        (<= attribs.y y)
                        (< y (+ attribs.y attribs.h)))
                       (if attribs.on-press (attribs.on-press))))))))

(kiwmi:on "view"
          (fn [view]
            (let [geom (placements (kiwmi:active_output))]
              (view:resize geom.application.w geom.application.h)
              (view:move geom.application.x geom.application.y))
            (view:focus)
            (view:show)
            (tset app-state :focus-view view)
            (table.insert app-state.views view)
            (view:on "request_move" #(view:imove))
            (view:on "request_resize" (fn [ev] (view:iresize ev.edges)))))

(kiwmi:spawn "swaybg -c '#ff00ff'")
(kiwmi:spawn "lua -l fennelrun modeline")
;(kiwmi:spawn "lua -l fennelrun saturn")
(kiwmi:spawn "lua -l fennelrun crier")
(kiwmi:spawn "lua -l fennelrun just https://brvt.telent.net")
;(kiwmi:spawn "foot")

;; Local Variables:
;; inferior-lisp-program: "eufonctl"
;; End:
