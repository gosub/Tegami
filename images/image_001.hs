import Tegami.Render (autoPPM)
import Tegami.Core (xor)
import Tegami.Shape (disc)
import Tegami.Transform (trans)

import Control.Applicative (liftA2)

main = autoPPM $ foldr1 (liftA2 xor) [disc . trans (0.1*x, 0) | x <- [0..10]]
