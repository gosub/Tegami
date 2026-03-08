import Tegami.Render (autoImage)
import Tegami.Shape (vesica)
import Tegami.Transform (zoom, rot)
import Tegami.Composition (tile)

image_038 = tile expo . zoom 0.3
  where
    expo r c | even (r+c) = vesica 0.9 0.35 . zoom 0.4
             | otherwise  = vesica 0.9 0.35 . rot (pi/2) . zoom 0.4

main = autoImage image_038
