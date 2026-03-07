import Tegami.Render (autoImage)
import Tegami.Shape (checkers, disc)
import Tegami.Transform (zoom)


image_009 = (&&) <$> checkers . zoom 0.25 <*> disc

main = autoImage $ image_009
