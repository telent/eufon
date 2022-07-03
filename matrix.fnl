;; homogeneous matrix operations for 2d graphics

(local identity
       [
        1 0 0
        0 1 0
        0 0 1
        ])

(fn multiply-matrix [a b]
  [
   (+ (* (. a 1) (. b 1))   (* (. a 2) (. b 4))   (* (. a 3) (. b 7)))
   (+ (* (. a 1) (. b 2))   (* (. a 2) (. b 5))   (* (. a 3) (. b 8)))
   (+ (* (. a 1) (. b 3))   (* (. a 2) (. b 6))   (* (. a 3) (. b 9)))

   (+ (* (. a 4) (. b 1))   (* (. a 5) (. b 4))   (* (. a 6) (. b 7)))
   (+ (* (. a 4) (. b 2))   (* (. a 5) (. b 5))   (* (. a 6) (. b 8)))
   (+ (* (. a 4) (. b 3))   (* (. a 5) (. b 6))   (* (. a 6) (. b 9)))

   (+ (* (. a 7) (. b 1))   (* (. a 8) (. b 4))   (* (. a 9) (. b 7)))
   (+ (* (. a 7) (. b 2))   (* (. a 8) (. b 5))   (* (. a 9) (. b 8)))
   (+ (* (. a 7) (. b 3))   (* (. a 8) (. b 6))   (* (. a 9) (. b 9)))
   ])

(fn scale [matrix x y]
  (let [scale [
               x 0 0
               0 y 0
               0 0 1]]
    (multiply-matrix matrix scale)))

(fn translate [matrix x y]
  (let [translation [
                     1 0 x
                     0 1 y
                     0 0 1]]
    (multiply-matrix matrix translation)))

(fn rotate [matrix rad]
  (let [sin (math.sin rad)
        cos (math.cos rad)
        rotation [
                  cos (- sin) 0
                  sin  cos    0
                  0     0     1
                  ]]
    (multiply-matrix matrix rotation)))


{
 : identity
 : scale
 : translate
 : rotate
 }
