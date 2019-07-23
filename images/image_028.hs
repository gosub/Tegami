import Tegami.Render (autoPPM)
import Tegami.Shape (disc, disc')
import Tegami.Core (xor)

import Control.Applicative (liftA2)


image_028 = concRings [0.9, 0.8, 0.7, 0.3, 0.2]
  where concRings sizes = foldl (liftA2 xor) disc $ discs sizes
        discs sizes = map disc' sizes

main = autoPPM $ image_028
