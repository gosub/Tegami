import Tegami.Render (autoImage)
import Tegami.Shape (checkers, stripe)
import Tegami.Transform (transpose, zoom, spiral)


image_021 = checkband . transpose . zoom 0.5 . spiral
  where checkband = (&&) <$> stripe <*> checkers . zoom 0.25

main = autoImage $ image_021
