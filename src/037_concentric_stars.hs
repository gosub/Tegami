import Tegami.Render (autoImage)
import Tegami.Shape (star)
import Tegami.Transform (zoom)
import Tegami.Composition (concentric_tile, tile)

image_037 = concentric_tile f . zoom 0.5
  where f n = tile (\_ _ -> star (n `mod` 8 + 3) 0.9 0.4 . zoom 0.4)

main = autoImage image_037
