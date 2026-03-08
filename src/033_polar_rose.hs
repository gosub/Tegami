import Tegami.Render (autoImage)
import Tegami.Core (cart2polar)
import Tegami.Transform (zoom)

rose n p = r <= abs (cos (fromIntegral n * theta))
  where (r, theta) = cart2polar p

image_033 = rose 5 . zoom 0.9

main = autoImage image_033
