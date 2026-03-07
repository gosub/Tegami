import Tegami.Render (autoImage)
import Tegami.Core (xor)
import Tegami.Shape (stripes)
import Tegami.Transform (zoom, wave)
import Tegami.Shift (shiftRot)

import Control.Applicative (liftA2)

main = autoImage $ shiftRot (liftA2 xor) (pi/4) $ stripes . zoom 0.2 . wave 2 3
