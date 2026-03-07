import Tegami.Render (autoImage)
import Tegami.Shape (tri)
import Tegami.Transform (rot)

import Control.Applicative (liftA2)

image_013 = foldr1 (liftA2 (||)) tris
  where tris = [t . rot (x * 2 * pi / n) | x <- [0..n-1]]
        t = tri (0, 1.2) ((-0.05), 0.2) (0.05, 0.2)
        n = 7

main = autoImage $ image_013
