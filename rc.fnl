(kiwmi:on "output" #(doto $1 (: :set_mode 360 720 0)))


;(kiwmi:spawn "swaybg -c '#ff00ff'")
(kiwmi:spawn "lua -l fennelrun modeline.fnl")
(kiwmi:spawn "foot")
