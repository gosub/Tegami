import Tegami.Render (autoPPM)
import Tegami.Shape (poly, disc, cross)
import Tegami.Transform (iso, trans)

import Control.Applicative (liftA2)


image_016 = stemma . iso 1 0.5
  where stemma = foldr1 (liftA2 (||)) [p1, p2, p3, p4, p5]
        p1 = poly 5 . trans ((-2),0)
        p2 = poly 4
        p3 = poly 3 . trans (2,0)
        p4 = disc . trans (0, 2)
        p5 = cross . trans (0, (-2))

main = autoPPM $ image_016
