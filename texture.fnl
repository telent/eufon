(local { : GdkPixbuf } (require :lgi))

(fn from-file [renderer filename]
  (let [pixels
        (let [(buf err) (GdkPixbuf.Pixbuf.new_from_file filename)]
          (if (not buf) (print :err err))
          buf)]
    (renderer:texture_from_pixels
     pixels.rowstride
     pixels.width
     pixels.height
     (pixels:get_pixels))))

{ : from-file }
