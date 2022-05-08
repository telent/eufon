(local { : GdkPixbuf } (require :lgi))
(local { : view } (require :fennel))




(fn texture-from-file [renderer filename]
  (let [pixels
        (let [(buf err) (GdkPixbuf.Pixbuf.new_from_file filename)]
          (if (not buf) (print :err err))
          buf)]
    (renderer:texture_from_pixels
     pixels.rowstride
     pixels.width
     pixels.height
     (pixels:get_pixels))))

(kiwmi:on
 "output"
 (fn [output]
   (output:set_mode 360 720 0)
   (let [r (output:renderer)
         kill (texture-from-file r "close-window.png")
         launch (texture-from-file r "launcher.png")
         spinner (texture-from-file r "carousel.png")]
     (output:on "render"
                (fn [{: output : renderer}]
                  (let [bar-height 40
                        matrix [1 0 0
                                0 1 0
                                0 0 1]]
                    (renderer:draw_rect :#00000077
                                        0 (- 720 bar-height)
                                        690 360 bar-height)
                    (renderer:draw_texture
                     kill
                     matrix
                     30 (- 720 bar-height)
                     0.7)
                    (renderer:draw_texture
                     launch matrix
                     (- 180 (/ bar-height 2)) (- 720 bar-height)
                     0.7)
                    (renderer:draw_texture
                     spinner
                     matrix
                     (- 360 30 bar-height) (- 720 bar-height)
                     0.7)))))))


(kiwmi:on "view"
          (fn [view]
            (let [(w h) (: (kiwmi:active_output) :size)]
              (view:resize w h)
              (view:move 0 0))
            (view:focus)
            (view:show)
            (view:on "request_move" #(view:imove))
            (view:on "request_resize" (fn [ev] (view:iresize ev.edges)))))


;(kiwmi:spawn "swaybg -c '#ff00ff'")
(kiwmi:spawn "lua -l fennelrun modeline.fnl")
(kiwmi:spawn "lua -l fennelrun saturn/main.fnl")
(kiwmi:spawn "lua -l fennelrun crier/crier.fnl")
(kiwmi:spawn "lua -l fennelrun just/just.fnl")
;(kiwmi:spawn "foot")
