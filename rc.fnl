(local { : GdkPixbuf } (require :lgi))
(local { : view } (require :fennel))

(var texture nil)

(local pixels
       (let [(buf err) (GdkPixbuf.Pixbuf.new_from_file "globe.png")]
         (if (not buf) (print :err err))
         buf))

(kiwmi:on
 "output"
 (fn [output]
   (output:set_mode 360 720 0)
   (let [r (output:renderer)]
     (set texture (r:texture_from_pixels
                   pixels.rowstride
                   pixels.width
                   pixels.height
                   (pixels:get_pixels)))
     (output:on "render"
                (fn [{: output : renderer}]
                  (renderer:draw_texture
                   texture
                   [1 0 0
                    0 1 0
                    0 0 1]
                   150 150 0.7)))
     (print :texture texture))))

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
