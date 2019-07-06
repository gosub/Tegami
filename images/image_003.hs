import Tegami.Render (autoPPM)
import Tegami.Core (xor)
import Tegami.Shape (cross)
import Tegami.Transform (zoom, ringer)
import Tegami.Shift (shiftRot)

import Control.Applicative (liftA2)

main = autoPPM $ (shiftRot xorI (pi/8) asterisk) . ringer 1 . zoom 0.5
                 where
                   xorI = liftA2 xor
                   asterisk = (shiftRot xorI (pi/4) cross)
