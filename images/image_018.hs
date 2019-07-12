import Tegami.Render (autoPPM)
import Tegami.Shape (cross)
import Tegami.Transform (zoom, mirror, slicer)
import Tegami.Shift (around)
import Tegami.Core (xor)

import Control.Applicative (liftA2)


image_018 = image_017 . slicer (pi/4) . mirror
  where image_017 = around (liftA2 xor) 1 12 $ cross . zoom 0.5

main = autoPPM $ image_018
