import Tegami.Render (autoImage)
import Tegami.Shape (arc)
import Tegami.Transform (zoom, rot)
import Control.Applicative (liftA2)

spoke a = arc 0.75 0.08 (pi/10) . rot a . zoom 0.9

image_034 = foldr1 (liftA2 (||)) [spoke (fromIntegral i * pi/4) | i <- [0..7]]

main = autoImage image_034
