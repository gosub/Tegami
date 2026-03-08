import Tegami.Render (autoImage)
import Tegami.Shape (star)
import Tegami.Transform (circleLimit, zoom)
import Tegami.Composition (tile)

tiledStars = tile (\_ _ -> star 6 0.9 0.4 . zoom 0.45)

image_032 = circleLimit (tiledStars . zoom 0.3) (const False) . zoom 2.5

main = autoImage image_032
