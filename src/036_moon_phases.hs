import Tegami.Render (autoImage)
import Tegami.Shape (moon)
import Tegami.Transform (zoom)
import Tegami.Composition (tile)

image_036 = tile expo . zoom 0.25
  where
    expo r c = moon d 0.85 0.7 . zoom 0.35
      where d = 0.2 + 1.2 * fromIntegral (abs c `mod` 8) / 7

main = autoImage image_036
