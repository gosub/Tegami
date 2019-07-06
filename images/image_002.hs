import Tegami.Render (autoPPM)
import Tegami.Core (xor)
import Tegami.Shape (stripes)
import Tegami.Transform (zoom, wave)
import Tegami.Shift (shiftRot)

import Control.Applicative (liftA2)

main = autoPPM $ shiftRot (liftA2 xor) (pi/4) $ stripes . zoom 0.2 . wave 2 3
